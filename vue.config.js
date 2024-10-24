const { defineConfig } = require('@vue/cli-service');

module.exports = defineConfig({
  transpileDependencies: true,

  configureWebpack: {
    resolve: {
      fallback: {
        crypto: false,
      },
    },
    module: {
      rules: [
        {
          test: /\.ts$/,
          loader: 'ts-loader',
          options: {
            appendTsSuffixTo: [/\.vue$/], // This ensures TypeScript works in Vue files
          },
          exclude: /node_modules/,
        },
      ],
    },
  },
});
