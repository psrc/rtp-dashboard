library(rsconnect)

# test version ----

deployApp(account = 'psrcwa',
          appName = 'development-rtp-dashboard',
          appTitle = 'Development RTP Dashboard')

# official version ----

deployApp(account = 'psrcwa',
         appName = 'rtp-dashboard',
         appTitle = 'RTP Dashboard')