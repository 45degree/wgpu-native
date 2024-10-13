add_requires('glfw')

target('example-triangle', function()
  set_kind('binary')
  add_files('*.c')
  add_deps('example-framework')

  if is_os('windows') then
    add_defines('GLFW_EXPOSE_NATIVE_WIN32')
  end
  add_defines('WGPU_SHARED_LIBRARY')

  add_packages('glfw')
  add_links('wgpu_native')

  on_load(function(target)
  	target:set("targetdir", path.join(target:targetdir(), "example", "triangle"))
  end)

  after_build(function(target)
    os.cp(path.join(os.scriptdir(), 'shader.wgsl'), target:targetdir())
  end)
end)
