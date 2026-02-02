pragma Singleton
import QtQuick

QtObject {
  // ============================================================================
  // MATUGEN SEMANTIC TOKENS
  // ============================================================================
    
  // --- Primary Colors (Main brand color) ---
  readonly property color primary: "{{colors.primary.default.hex}}"
  readonly property color on_primary: "{{colors.on_primary.default.hex}}"
  readonly property color primary_container: "{{colors.primary_container.default.hex}}"
  readonly property color on_primary_container: "{{colors.on_primary_container.default.hex}}"
  readonly property color primary_fixed: "{{colors.primary_fixed.default.hex}}"
  readonly property color primary_fixed_dim: "{{colors.primary_fixed_dim.default.hex}}"
  readonly property color on_primary_fixed: "{{colors.on_primary_fixed.default.hex}}"
  readonly property color on_primary_fixed_variant: "{{colors.on_primary_fixed_variant.default.hex}}"
    
  // --- Secondary Colors (Supporting color) ---
  readonly property color secondary: "{{colors.secondary.default.hex}}"
  readonly property color on_secondary: "{{colors.on_secondary.default.hex}}"
  readonly property color secondary_container: "{{colors.secondary_container.default.hex}}"
  readonly property color on_secondary_container: "{{colors.on_secondary_container.default.hex}}"
  readonly property color secondary_fixed: "{{colors.secondary_fixed.default.hex}}"
  readonly property color secondary_fixed_dim: "{{colors.secondary_fixed_dim.default.hex}}"
  readonly property color on_secondary_fixed: "{{colors.on_secondary_fixed.default.hex}}"
  readonly property color on_secondary_fixed_variant: "{{colors.on_secondary_fixed_variant.default.hex}}"
    
  // --- Tertiary Colors (Third accent) ---
  readonly property color tertiary: "{{colors.tertiary.default.hex}}"
  readonly property color on_tertiary: "{{colors.on_tertiary.default.hex}}"
  readonly property color tertiary_container: "{{colors.tertiary_container.default.hex}}"
  readonly property color on_tertiary_container: "{{colors.on_tertiary_container.default.hex}}"
  readonly property color tertiary_fixed: "{{colors.tertiary_fixed.default.hex}}"
  readonly property color tertiary_fixed_dim: "{{colors.tertiary_fixed_dim.default.hex}}"
  readonly property color on_tertiary_fixed: "{{colors.on_tertiary_fixed.default.hex}}"
  readonly property color on_tertiary_fixed_variant: "{{colors.on_tertiary_fixed_variant.default.hex}}"
    
  // --- Error Colors ---
  readonly property color error: "{{colors.error.default.hex}}"
  readonly property color on_error: "{{colors.on_error.default.hex}}"
  readonly property color error_container: "{{colors.error_container.default.hex}}"
  readonly property color on_error_container: "{{colors.on_error_container.default.hex}}"
    
  // --- Background Colors ---
  readonly property color background: "{{colors.background.default.hex}}"
  readonly property color on_background: "{{colors.on_background.default.hex}}"
    
  // --- Surface Colors (5-level elevation system) ---
  readonly property color surface: "{{colors.surface.default.hex}}"
  readonly property color on_surface: "{{colors.on_surface.default.hex}}"
  readonly property color surface_variant: "{{colors.surface_variant.default.hex}}"
  readonly property color on_surface_variant: "{{colors.on_surface_variant.default.hex}}"
    
  readonly property color surface_dim: "{{colors.surface_dim.default.hex}}"
  readonly property color surface_bright: "{{colors.surface_bright.default.hex}}"
  readonly property color surface_container_lowest: "{{colors.surface_container_lowest.default.hex}}"
  readonly property color surface_container_low: "{{colors.surface_container_low.default.hex}}"
  readonly property color surface_container: "{{colors.surface_container.default.hex}}"
  readonly property color surface_container_high: "{{colors.surface_container_high.default.hex}}"
  readonly property color surface_container_highest: "{{colors.surface_container_highest.default.hex}}"
    
  // --- Outline Colors (Borders) ---
  readonly property color outline: "{{colors.outline.default.hex}}"
  readonly property color outline_variant: "{{colors.outline_variant.default.hex}}"
    
  // --- Inverse Colors (for dark/light theme switching) ---
  readonly property color inverse_surface: "{{colors.inverse_surface.default.hex}}"
  readonly property color inverse_on_surface: "{{colors.inverse_on_surface.default.hex}}"
  readonly property color inverse_primary: "{{colors.inverse_primary.default.hex}}"
    
  // --- Scrim & Shadow ---
  readonly property color scrim: "{{colors.scrim.default.hex}}"
  readonly property color shadow: "{{colors.shadow.default.hex}}"

  // ============================================================================
  // TRANSPARENT VARIANTS - FOR BLUR EFFECTS
  // ============================================================================
  // Light = 60-65% opacity (subtle blur, good visibility)
  // Medium = 75-80% opacity (balanced blur, most common)
  // Heavy = 90-92% opacity (strong blur, near-opaque)

  // --- Primary Transparencies ---
  readonly property color primary_transparent_light: Qt.rgba(primary.r, primary.g, primary.b, 0.25)
  readonly property color primary_transparent_medium: Qt.rgba(primary.r, primary.g, primary.b, 0.40)
  readonly property color primary_transparent_heavy: Qt.rgba(primary.r, primary.g, primary.b, 0.60)

  // --- Surface Transparencies (for backgrounds) ---
  readonly property color surface_transparent_light: Qt.rgba(surface.r, surface.g, surface.b, 0.50)
  readonly property color surface_transparent_medium: Qt.rgba(surface.r, surface.g, surface.b, 0.70)
  readonly property color surface_transparent_heavy: Qt.rgba(surface.r, surface.g, surface.b, 0.85)

  // --- Surface Container Transparencies (for main panels/popups) ---
  readonly property color surface_container_transparent_light: Qt.rgba(surface_container.r, surface_container.g, surface_container.b, 0.60)
  readonly property color surface_container_transparent_medium: Qt.rgba(surface_container.r, surface_container.g, surface_container.b, 0.75)
  readonly property color surface_container_transparent_heavy: Qt.rgba(surface_container.r, surface_container.g, surface_container.b, 0.90)

  // --- Surface Container Low Transparencies (for lower elevation cards) ---
  readonly property color surface_container_low_transparent_light: Qt.rgba(surface_container_low.r, surface_container_low.g, surface_container_low.b, 0.50)
  readonly property color surface_container_low_transparent_medium: Qt.rgba(surface_container_low.r, surface_container_low.g, surface_container_low.b, 0.65)
  readonly property color surface_container_low_transparent_heavy: Qt.rgba(surface_container_low.r, surface_container_low.g, surface_container_low.b, 0.80)

  // --- Surface Container High Transparencies (for higher elevation cards) ---
  readonly property color surface_container_high_transparent_light: Qt.rgba(surface_container_high.r, surface_container_high.g, surface_container_high.b, 0.70)
  readonly property color surface_container_high_transparent_medium: Qt.rgba(surface_container_high.r, surface_container_high.g, surface_container_high.b, 0.85)
  readonly property color surface_container_high_transparent_heavy: Qt.rgba(surface_container_high.r, surface_container_high.g, surface_container_high.b, 0.95)

  // --- Scrim Transparencies (for modal overlays) ---
  readonly property color scrim_transparent_light: Qt.rgba(scrim.r, scrim.g, scrim.b, 0.15)
  readonly property color scrim_transparent_medium: Qt.rgba(scrim.r, scrim.g, scrim.b, 0.45)
  readonly property color scrim_transparent_heavy: Qt.rgba(scrim.r, scrim.g, scrim.b, 0.65)
    
  // ============================================================================
  // SPACING SYSTEM
  // ============================================================================
    
  readonly property QtObject spacing: QtObject {
    readonly property int xs: 4
    readonly property int sm: 8
    readonly property int md: 12
    readonly property int lg: 18
    readonly property int xl: 26 
    readonly property int xxl: 48
  }
    
  // ============================================================================
  // PADDING SYSTEM
  // ============================================================================
    
  readonly property QtObject padding: QtObject {
    readonly property int xs: 4
    readonly property int sm: 8
    readonly property int md: 12
    readonly property int lg: 18
    readonly property int xl: 20
  }
    
  // ============================================================================
  // TYPOGRAPHY SYSTEM
  // ============================================================================
    
  readonly property QtObject typography: QtObject {
    readonly property string fontFamily: "Google Sans"
    readonly property string fontFamilyDisplay: "Google Sans"
        
    readonly property int xs: 10
    readonly property int sm: 12
    readonly property int md: 14
    readonly property int lg: 16
    readonly property int xl: 18
    readonly property int xxl: 24
    readonly property int xxxl: 32
        
    readonly property int weightNormal: 400
    readonly property int weightMedium: 500
    readonly property int weightBold: 700
  }
    
  // ============================================================================
  // SHAPE SYSTEM (Border Radius)
  // ============================================================================
    
  readonly property QtObject radius: QtObject {
    readonly property int none: 0
    readonly property int sm: 6
    readonly property int md: 12
    readonly property int lg: 20
    readonly property int xl: 32 
    readonly property int xxl: 40
    readonly property int full: 9999
  }
    
  // ============================================================================
  // COMPONENT TOKENS
  // ============================================================================
    
  readonly property QtObject component: QtObject {
    readonly property int barHeight: 26
    readonly property int workspaceIndicatorSize: 10
    readonly property int buttonHeight: 36
    readonly property int inputHeight: 40
  }

  // ============================================================================
  // CONVENIENCE ALIASES
  // ============================================================================
  // Common top-level shortcuts to avoid nested property access

  readonly property string fontFamily: typography.fontFamily
  readonly property int barHeight: component.barHeight
  readonly property int workspaceIndicatorSize: component.workspaceIndicatorSize
}
