add_rules('mode.release', 'mode.debug')
target('wgpu_native', function()
  set_kind('shared')

  add_headerfiles('ffi/wgpu.h')
  add_headerfiles('ffi/webgpu-headers/webgpu.h')

  add_includedirs('ffi', { public = true })
  add_includedirs('ffi/webgpu-headers', { public = true })

  on_build(function(target)
    import('lib.detect.find_tool')
    import('core.project.config')
    local cargo = find_tool('cargo')

    os.execv(cargo.program, { 'build', config.mode() == 'release' and '--release' or nil })
  end)

  after_build(function(target)
    import('core.project.config')
    if not os.isdir(target:targetdir()) then
      if os.exists(target:targetdir()) then
        os.rmdir(target:targetdir())
      end
      os.mkdir(target:targetdir())
    end
    if config.mode() == 'debug' then
      os.cp(path.join('target', 'debug', '*.pdb'), target:targetdir())
      os.cp(path.join('target', 'debug', '*.ilk'), target:targetdir())
      os.cp(path.join('target', 'debug', 'wgpu_native.dll'), path.join(target:targetdir(), 'wgpu_native.dll'))
      os.cp(path.join('target', 'debug', 'wgpu_native.dll.lib'), path.join(target:targetdir(), 'wgpu_native.lib'))
    else
      os.cp(path.join('target', 'release', 'wgpu_native.dll'), path.join(target:targetdir(), 'wgpu_native.dll'))
      os.cp(path.join('target', 'release', 'wgpu_native.dll.lib'), path.join(target:targetdir(), 'wgpu_native.lib'))
    end

  end)
end)

includes('examples')
