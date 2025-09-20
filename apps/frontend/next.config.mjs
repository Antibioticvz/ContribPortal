/** @type {import('next').NextConfig} */
const nextConfig = {
  transpilePackages: [],
  eslint: {
    dirs: ['src'],
  },
  images: {
    domains: [],
  },
};

export default nextConfig;