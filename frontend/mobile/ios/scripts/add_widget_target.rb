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

bundle_identifier =
  "com.adam.festivalcompanion.NextSetWidget"

deployment_target =
  "17.0"

runner_target =
  project.targets.find do |target|
    target.name == "Runner"
  end

unless runner_target
  abort(
    "Runner target was not found."
  )
end

widget_target =
  project.targets.find do |target|
    target.name == target_name
  end

if widget_target
  puts(
    "Repairing existing #{target_name} target."
  )
else
  widget_target =
    project.new_target(
      :app_extension,
      target_name,
      :ios,
      deployment_target
    )

  puts(
    "Created #{target_name} target."
  )
end

# Explicitly name the extension product. Without this,
# Xcode may try to produce a file named only ".appex".
widget_target.product_reference.name =
  "#{target_name}.appex"

widget_target.product_reference.path =
  "#{target_name}.appex"

widget_target.product_reference.explicit_file_type =
  "wrapper.app-extension"

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
  widget_group.files.find do |file|
    file.path ==
      "NextSetWidget.swift"
  end

swift_reference ||=
  widget_group.new_file(
    "NextSetWidget.swift"
  )

info_reference =
  widget_group.files.find do |file|
    file.path ==
      "Info.plist"
  end

info_reference ||=
  widget_group.new_file(
    "Info.plist"
  )

unless widget_target
         .source_build_phase
         .files_references
         .include?(
           swift_reference
         )
  widget_target
    .source_build_phase
    .add_file_reference(
      swift_reference
    )
end

widget_target
  .build_configurations
  .each do |configuration|
    settings =
      configuration.build_settings

    settings[
      "PRODUCT_BUNDLE_IDENTIFIER"
    ] =
      bundle_identifier

    settings[
      "PRODUCT_NAME"
    ] =
      target_name

    settings[
      "EXECUTABLE_NAME"
    ] =
      "$(PRODUCT_NAME)"

    settings[
      "WRAPPER_EXTENSION"
    ] =
      "appex"

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
      file.path.end_with?(
        framework_name
      )
    end

  reference ||=
    framework_group.new_file(
      "System/Library/Frameworks/#{framework_name}",
      :sdk_root
    )

  unless widget_target
           .frameworks_build_phase
           .files_references
           .include?(
             reference
           )
    widget_target
      .frameworks_build_phase
      .add_file_reference(
        reference,
        true
      )
  end
end

unless runner_target.dependencies.any? do |dependency|
         dependency.target ==
           widget_target
       end
  runner_target.add_dependency(
    widget_target
  )
end

embed_phase =
  runner_target
    .copy_files_build_phases
    .find do |phase|
      phase.name ==
        "Embed App Extensions"
    end

unless embed_phase
  embed_phase =
    runner_target
      .new_copy_files_build_phase(
        "Embed App Extensions"
      )

  embed_phase.dst_subfolder_spec =
    "13"
end

unless embed_phase
         .files_references
         .include?(
           widget_target
             .product_reference
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
  "Configured #{target_name}."
)

puts(
  "Product: #{widget_target.product_reference.path}"
)

puts(
  "Bundle ID: #{bundle_identifier}"
)