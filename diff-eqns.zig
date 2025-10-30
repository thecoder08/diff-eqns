const xgfx = @cImport(@cInclude("xgfx/window.h"));
const drawing = @cImport(@cInclude("xgfx/drawing.h"));
const print = @import("std").debug.print;
const math = @import("std").math;

pub fn main() void {
    xgfx.initWindow(640, 480, "Pendulum Sim");
    var theta: f32 = 2;
    var thetaSpeed: f32 = 0.1;
    const deltaT = 1;
    const g = 0.005;
    while (true) {
        var event: xgfx.Event = undefined;
        while (xgfx.checkWindowEvent(&event) != 0) {
            switch (event.type) {
                xgfx.WINDOW_CLOSE => {
                    return;
                },
                else => {},
            }
        }
        thetaSpeed += (g * math.sin(theta) - 0.001 * thetaSpeed) * deltaT;
        theta += thetaSpeed * deltaT;
        const pendulumLength = 200;
        const pendulumX: i32 = @intFromFloat(pendulumLength * math.sin(theta));
        const pendulumY: i32 = @intFromFloat(pendulumLength * -math.cos(theta));
        drawing.clear();
        drawing.line(320, 240, 320 + pendulumX, 240 + pendulumY, 0x0000ff00);
        drawing.circle(320 + pendulumX, 240 + pendulumY, 10, 0x0000ff00);
        xgfx.updateWindow();
    }
}
