# Stage 1: We use nginx to serve static files
# Using a specific digest is more secure than just 'latest'
FROM nginx:1.25-alpine
 
# Create non-root user for security
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup
 
# Copy our web files
COPY src/ /usr/share/nginx/html/
 
# Copy custom nginx config (more secure than default)
COPY nginx.conf /etc/nginx/nginx.conf
 
# Change ownership to non-root user
RUN chown -R appuser:appgroup /usr/share/nginx/html && \
    chown -R appuser:appgroup /var/cache/nginx && \
    chown -R appuser:appgroup /var/log/nginx && \
    touch /var/run/nginx.pid && \
    chown -R appuser:appgroup /var/run/nginx.pid
 
USER appuser
 
EXPOSE 8080
 
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080 || exit 1
 
CMD ["nginx", "-g", "daemon off;"]
