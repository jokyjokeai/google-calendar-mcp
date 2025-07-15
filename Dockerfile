# Google Calendar MCP Server - Optimized Dockerfile
FROM node:18-alpine

# Create app user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S -u 1001 -G nodejs nodejs

# Set working directory
WORKDIR /app

# Copy package files for dependency caching
COPY package*.json ./

# Copy build scripts and source files needed for build
COPY scripts ./scripts
COPY src ./src
COPY tsconfig.json .

# Install all dependencies (including dev dependencies for build)
RUN npm ci --no-audit --no-fund --silent

# Build the project
RUN npm run build

# Remove dev dependencies to reduce image size
RUN npm prune --production --silent

# Create config directory and set permissions
RUN mkdir -p /home/nodejs/.config/google-calendar-mcp && \
    chown -R nodejs:nodejs /home/nodejs/.config && \
    chown -R nodejs:nodejs /app

# Copy startup script
COPY startup.sh /app/
RUN chmod +x /app/startup.sh && chown nodejs:nodejs /app/startup.sh

# Switch to non-root user
USER nodejs

# Expose port for SSE transport
EXPOSE 8000

# Use startup script to handle tokens
CMD ["/app/startup.sh"]
