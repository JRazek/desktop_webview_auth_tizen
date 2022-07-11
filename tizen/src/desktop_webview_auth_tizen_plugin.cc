#include "desktop_webview_auth_tizen_plugin.h"

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar.h>
#include <flutter/standard_method_codec.h>
#include <system_info.h>

#include <memory>
#include <string>

#include "log.h"

namespace {

class DesktopWebviewAuthTizenPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrar *registrar) {
    auto plugin = std::make_unique<DesktopWebviewAuthTizenPlugin>();

    registrar->AddPlugin(std::move(plugin));
  }

  DesktopWebviewAuthTizenPlugin() {}

  virtual ~DesktopWebviewAuthTizenPlugin() {}
};

}  // namespace

void DesktopWebviewAuthTizenPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  DesktopWebviewAuthTizenPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrar>(registrar));
}
