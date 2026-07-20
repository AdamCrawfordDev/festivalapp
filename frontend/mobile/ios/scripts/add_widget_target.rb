require "xcodeproj"

project_path =
  File.expand_path(
    "../Runner.xcodeproj",
    __dir__
  )

project =
  Xcodeproj::Project.open(
    project_path
  )

target_name =
  "NextSetWidget"

existing_target =
  project.targets.find do |target|
    target.name == target_name
  end

if existing_target
  puts(
    "#{target_name} target already exists."
  )

  project.save
  exit 0
end

runner_target =
  project.targets.find do |target|
    target.name == "Runner"
  end

unless runner_target
  abort(
    "Runner target was not found."
  )
end

deployment_target =
  "17.0"

widget_target =
  project.new_target(
    :app_extension,
    target_name,
    :ios,
    deployment_target
  )

widget_target.product_name =
  target_name

widget_group =
  project.main_group.find_subpath(
    target_name,
    true
  )

widget_group.set_source_tree(
  "<group>"
)

widget_group.path =
  target_name

swift_reference =
  widget_group.new_file(
    "NextSetWidget.swift"
  )

info_reference =
  widget_group.new_file(
    "Info.plist"
  )

widget_target
  .source_build_phase
  .add_file_reference(
    swift_reference
  )

widget_target.build_configurations.each do |configuration|
  settings =
    configuration.build_settings

  settings[
    "PRODUCT_BUNDLE_IDENTIFIER"
  ] =
    "com.adam.festivalcompanion.NextSetWidget"

  settings[
    "INFOPLIST_FILE"
  ] =
    "NextSetWidget/Info.plist"

  settings[
    "SWIFT_VERSION"
  ] =
    "5.0"

  settings[
    "IPHONEOS_DEPLOYMENT_TARGET"
  ] =
    deployment_target

  settings[
    "TARGETED_DEVICE_FAMILY"
  ] =
    "1,2"

  settings[
    "SKIP_INSTALL"
  ] =
    "YES"

  settings[
    "APPLICATION_EXTENSION_API_ONLY"
  ] =
    "YES"

  settings[
    "GENERATE_INFOPLIST_FILE"
  ] =
    "NO"

  settings[
    "MARKETING_VERSION"
  ] =
    "1.0"

  settings[
    "CURRENT_PROJECT_VERSION"
  ] =
    "1"

  settings[
    "CODE_SIGNING_ALLOWED"
  ] =
    "NO"

  settings[
    "CODE_SIGNING_REQUIRED"
  ] =
    "NO"
end

frameworks = [
  "WidgetKit.framework",
  "SwiftUI.framework",
]

framework_group =
  project.frameworks_group

frameworks.each do |framework_name|
  reference =
    framework_group.files.find do |file|
      file.path == framework_name
    end

  reference ||=
    framework_group.new_file(
      "System/Library/Frameworks/#{framework_name}",
      :sdk_root
    )

  widget_target
    .frameworks_build_phase
    .add_file_reference(
      reference,
      true
    )
end

runner_target.add_dependency(
  widget_target
)

embed_phase =
  runner_target.copy_files_build_phases.find do |phase|
    phase.name ==
      "Embed App Extensions"
  end

unless embed_phase
  embed_phase =
    runner_target.new_copy_files_build_phase(
      "Embed App Extensions"
    )

  embed_phase.dst_subfolder_spec =
    "13"
end

unless embed_phase.files_references.include?(
  widget_target.product_reference
)
  build_file =
    embed_phase.add_file_reference(
      widget_target.product_reference,
      true
    )

  build_file.settings = {
    "ATTRIBUTES" => [
      "RemoveHeadersOnCopy",
    ],
  }
end

project.save

puts(
  "Created and embedded #{target_name}."
)