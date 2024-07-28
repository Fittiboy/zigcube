const std = @import("std");
const rl = @import("raylib");
const gl = rl.gl;

const dark_mode = true;
const show_grid = false;

pub fn main() !void {
    const screen_width = 640;
    const screen_height = 360;

    const cube_side = 1;
    const size = rl.Vector3{ .x = cube_side, .y = cube_side, .z = cube_side };
    const position = rl.Vector3{ .x = 0, .y = 0, .z = 0 };
    const x_rot = 45;
    const y_center: f32 = std.math.sqrt(3.0) * cube_side / 2.0;
    const z_rot = std.math.radiansToDegrees(std.math.atan(@as(f32, std.math.sqrt1_2)));

    rl.setConfigFlags(.{ .window_resizable = true, .vsync_hint = true });
    rl.initWindow(screen_width, screen_height, "Draw a Rotating Cube");
    defer rl.closeWindow();

    var camera = rl.Camera{
        .position = .{ .x = 3, .y = 3, .z = 3 },
        .target = .{ .x = 0, .y = y_center, .z = 0 }, // Center of cube
        .up = .{ .x = 0, .y = 1, .z = 0 },
        .fovy = 45, // Camera field-of-view Y
        .projection = rl.CameraProjection.camera_perspective,
    };

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) // Detect window close button or ESC key
    {
        rl.updateCamera(&camera, rl.CameraMode.camera_orbital);

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(if (dark_mode) rl.Color.black else rl.Color.white);
        {
            rl.beginMode3D(camera);
            defer rl.endMode3D();
            {
                gl.rlPushMatrix();
                defer gl.rlPopMatrix();
                gl.rlTranslatef(0, y_center, 0);
                gl.rlRotatef(z_rot, 0, 0, 1);
                gl.rlRotatef(x_rot, 1, 0, 0);
                rl.drawCubeWiresV(position, size, if (dark_mode) rl.Color.lime else rl.Color.black);
            }
            if (show_grid) rl.drawGrid(12, 0.75);
        }
    }
}
