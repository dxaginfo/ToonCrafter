# ToonCrafter Deployment Guide

This guide provides multiple deployment options for the ToonCrafter application.

## 🚀 Quick Start

### Option 1: Docker Deployment (Recommended)

#### Prerequisites
- Docker and Docker Compose installed
- NVIDIA GPU with CUDA support (optional, for acceleration)
- At least 8GB RAM
- 10GB free disk space

#### Steps
1. **Clone the repository** (if not already done):
   ```bash
   git clone <repository-url>
   cd ToonCrafter
   ```

2. **Run the deployment script**:
   - **Linux/macOS**: `chmod +x deploy.sh && ./deploy.sh`
   - **Windows**: `.\deploy.ps1`

3. **Access the application**:
   - Open your browser and go to: `http://localhost:7860`

### Option 2: Manual Docker Deployment

1. **Build and run with Docker Compose**:
   ```bash
   docker-compose up -d
   ```

2. **Or build and run manually**:
   ```bash
   docker build -t tooncrafter .
   docker run -p 7860:7860 --gpus all tooncrafter
   ```

### Option 3: Local Development Deployment

#### Prerequisites
- Python 3.8+
- CUDA-compatible GPU (recommended)
- 8GB+ RAM

#### Steps
1. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

2. **Run the application**:
   ```bash
   python gradio_app.py
   ```

3. **Access the application**:
   - Open your browser and go to: `http://localhost:7860`

## 🔧 Configuration

### Environment Variables

You can customize the deployment by setting environment variables:

- `CUDA_VISIBLE_DEVICES`: Specify which GPU to use (default: 0)
- `GRADIO_SERVER_PORT`: Change the port (default: 7860)
- `GRADIO_SERVER_NAME`: Change the server address (default: 0.0.0.0)

### GPU Configuration

For GPU acceleration, ensure you have:
1. NVIDIA drivers installed
2. CUDA toolkit installed
3. nvidia-docker2 installed (for Docker deployment)

## 📊 Resource Requirements

### Minimum Requirements
- **CPU**: 4 cores
- **RAM**: 8GB
- **Storage**: 10GB
- **GPU**: Optional (CPU-only mode available)

### Recommended Requirements
- **CPU**: 8+ cores
- **RAM**: 16GB+
- **Storage**: 20GB+
- **GPU**: NVIDIA GPU with 8GB+ VRAM

## 🐛 Troubleshooting

### Common Issues

#### 1. Docker Build Fails
```bash
# Check Docker logs
docker-compose logs

# Rebuild without cache
docker-compose build --no-cache
```

#### 2. GPU Not Detected
```bash
# Check NVIDIA Docker installation
docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi

# Install nvidia-docker2 if needed
# Follow: https://github.com/NVIDIA/nvidia-docker
```

#### 3. Out of Memory Errors
- Reduce batch size in the application
- Close other GPU-intensive applications
- Consider using CPU-only mode

#### 4. Model Download Issues
```bash
# Check internet connection
curl -I https://huggingface.co

# Manual model download (if needed)
python -c "from huggingface_hub import hf_hub_download; hf_hub_download(repo_id='Doubiiu/ToonCrafter', filename='model.ckpt', local_dir='./checkpoints/tooncrafter_512_interp_v1/')"
```

### Performance Optimization

#### For Production Deployment
1. **Use GPU acceleration** when available
2. **Increase Docker memory limits**:
   ```yaml
   # In docker-compose.yml
   deploy:
     resources:
       limits:
         memory: 16G
   ```
3. **Use SSD storage** for better I/O performance
4. **Consider load balancing** for multiple users

#### For Development
1. **Use CPU-only mode** for testing
2. **Reduce model resolution** for faster inference
3. **Use smaller batch sizes**

## 🔄 Maintenance

### Updating the Application
```bash
# Pull latest changes
git pull

# Rebuild and restart
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### Monitoring
```bash
# View logs
docker-compose logs -f

# Check resource usage
docker stats

# Monitor GPU usage
nvidia-smi
```

### Backup
```bash
# Backup results and checkpoints
tar -czf tooncrafter_backup_$(date +%Y%m%d).tar.gz results/ checkpoints/
```

## 🌐 Production Deployment

### Cloud Platforms

#### AWS
- Use EC2 with GPU instances (g4dn.xlarge or larger)
- Use ECS/EKS for container orchestration
- Use CloudFront for content delivery

#### Google Cloud
- Use Compute Engine with GPU instances
- Use GKE for container orchestration
- Use Cloud CDN for content delivery

#### Azure
- Use Azure VM with GPU instances
- Use AKS for container orchestration
- Use Azure CDN for content delivery

### Load Balancing
For multiple users, consider:
- Using a reverse proxy (nginx, traefik)
- Implementing request queuing
- Using multiple instances behind a load balancer

### Security
- Use HTTPS in production
- Implement authentication if needed
- Restrict network access
- Regular security updates

## 📞 Support

If you encounter issues:
1. Check the troubleshooting section above
2. Review the application logs
3. Check the [original ToonCrafter repository](https://github.com/Doubiiu/ToonCrafter)
4. Open an issue with detailed error information 