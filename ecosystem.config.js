module.exports = {
    apps : [{
      name   : 'service',
      script : './server.js',
      exec_mode: 'cluster',
      instances: 2
    }]
  }