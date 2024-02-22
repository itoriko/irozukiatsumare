# rack-mini-profiler（画面の左上に出てくる〇〇ms）の非表示
if Rails.env.development?
  Rack::MiniProfiler.config.start_hidden = false
end