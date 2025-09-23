const js = require('@eslint/js');
const googleConfig = require('eslint-config-google');
const globals = require('globals');

module.exports = [
  {
    ignores: [
      'app/assets/builds/*',
      'coverage/*',
      'node_modules/*',
      'public/assets/*',
    ],
  },
  {
    files: ['**/*.js'],
    ...js.configs.recommended,
    ...googleConfig,
    rules: {
      ...js.configs.recommended.rules,
      ...googleConfig.rules,
      'max-len': ['error', {code: 120}],
      'valid-jsdoc': 'off',
      'require-jsdoc': 'off',
    },
  },
  {
    files: ['app/assets/javascripts/**/*.js', 'public/**/*.js'],
    languageOptions: {
      globals: {
        ...globals.browser,
        '$': 'readonly',
        'bootstrap': 'readonly',
        'ClipboardJS': 'readonly',
      },
    },
  },
  {
    files: ['*.config.js'],
    languageOptions: {
      globals: {...globals.node},
    },
  },
];
