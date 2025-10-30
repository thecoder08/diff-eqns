const xgfx = @cImport(@cInclude("xgfx/window.h"));
const drawing = @cImport(@cInclude("xgfx/drawing.h"));
const print = @import("std").debug.print;
const math = @import("std").math;

pub fn main() void {
    xgfx.initWindow(640, 480, "Kinematics/Inverse Kinematics");
    var mouseX: i32 = 0;
    var mouseY: i32 = 0;
    while (true) {
        var event: xgfx.Event = undefined;
        while (xgfx.checkWindowEvent(&event) != 0) {
            switch (event.type) {
                xgfx.WINDOW_CLOSE => {
                    return;
                },
                xgfx.MOUSE_MOVE => {
                    mouseX = event.mousemove.x;
                    mouseY = event.mousemove.y;
                },
                else => {},
            }
        }
        // inverse kinematics
        const x: f32 = @floatFromInt(mouseX - 320);
        const y: f32 = @floatFromInt(mouseY - 240);
        var theta2 = math.acos((x * x + y * y - 100 * 100 - 100 * 100) / (2 * 100 * 100));
        var theta1 = math.atan(y / x) - math.atan((100 * math.sin(theta2)) / (100 + 100 * math.cos(theta2)));
        if (math.isNan(theta1) or math.isNan(theta2)) {
            theta1 = math.atan(y / x);
            theta2 = 0;
        }
        theta2 += theta1;
        if (x < 0) {
            theta1 += math.pi;
            theta2 += math.pi;
        }
        // forward kinematics
        const x1: i32 = @intFromFloat(100 * math.cos(theta1));
        const y1: i32 = @intFromFloat(100 * math.sin(theta1));
        const x2: i32 = @intFromFloat(100 * math.cos(theta2));
        const y2: i32 = @intFromFloat(100 * math.sin(theta2));
        drawing.clear();
        drawing.line(320, 240, 320 + x1, 240 + y1, 0x0000ff00);
        drawing.line(320 + x1, 240 + y1, 320 + x1 + x2, 240 + y1 + y2, 0x0000ff00);
        drawing.circle(320 + x1 + x2, 240 + y1 + y2, 10, 0x0000ff00);
        xgfx.updateWindow();
    }
}
