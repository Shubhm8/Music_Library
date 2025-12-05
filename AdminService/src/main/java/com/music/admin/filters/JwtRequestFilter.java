package com.music.admin.filters;

import com.music.admin.util.JwtUtil;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;

@Component
public class JwtRequestFilter extends OncePerRequestFilter {

    @Autowired
    private JwtUtil jwtUtil;

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) throws ServletException {
        String path = request.getServletPath();
        // Exclude login/register and static resources from filtering
        return path.equals("/admin/login") ||
               path.equals("/admin/perform_login") ||
               path.equals("/api/admin/login") ||
               path.equals("/api/admin/register") ||
               path.startsWith("/css/") ||
               path.startsWith("/js/") ||
               path.startsWith("/images/") ||
               path.startsWith("/audio/") ||
               path.startsWith("/swagger") ||
               path.startsWith("/v3/api-docs") ||
               path.startsWith("/v2/api-docs") ||
               path.startsWith("/h2-console");
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {

        String token = null;
        String username = null;

        // 1) Try Authorization header (Bearer ...)
        final String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            token = authHeader.substring(7);
        }

        // 2) Fallback to cookie (for older frontends)
        if (token == null && request.getCookies() != null) {
            for (Cookie cookie : request.getCookies()) {
                if ("jwtToken".equals(cookie.getName())) {
                    token = cookie.getValue();
                    break;
                }
            }
        }

        if (token != null) {
            try {
                username = jwtUtil.extractUsername(token);
            } catch (Exception ignored) {
                username = null;
            }
        }

        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
            UserDetails userDetails = new User(username, "", Collections.emptyList());

            if (jwtUtil.validateToken(token, username)) {
                UsernamePasswordAuthenticationToken auth =
                        new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());

                auth.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(auth);
            }
        }

        chain.doFilter(request, response);
    }
}
