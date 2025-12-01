const xgfx = @cImport(@cInclude("xgfx/window.h"));
const drawing = @cImport(@cInclude("xgfx/drawing.h"));
const print = @import("std").debug.print;
const math = @import("std").math;

pub fn main() void {
    xgfx.initWindow(640, 480, "Lotka-Volterra Equations");
    var popX: f32 = 2;
    var popY: f32 = 1;
    var oldX: f32 = 0;
    var oldY: f32 = 0;
    const alpha = 1;
    const beta = 1;
    const gamma = 1;
    const delta = 1;
    const deltaT = 0.001;
    var x: i32 = 0;
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
        const startDrawX = popX;
        const startDrawY = popY;
        for (0..30) |_| {
            oldX = popX;
            oldY = popY;
            popX += (alpha * oldX - beta * oldX * oldY) * deltaT;
            popY += (delta * oldX * oldY - gamma * oldY) * deltaT;
        }

        drawing.line(x, 479 - @as(i32, @intFromFloat(startDrawX * 200)), x, 479 - @as(i32, @intFromFloat(popX * 200)), 0x0000ff00);
        drawing.line(x, 479 - @as(i32, @intFromFloat(startDrawY * 200)), x, 479 - @as(i32, @intFromFloat(popY * 200)), 0x000000ff);
        xgfx.updateWindow();
        x += 1;
        //print("k_fwd/k_rev: {d}, concB/concA: {d}\n", .{ kFwd / kRev, concB / concA });
    }
}

// r_fwd = k_fwd * [A]
// d[A]/dt = k_fwd * -[A] (rate of consumption of A)
// d[B]/dt = k_fwd * [A] (rate of production of B)

// r_rev = k_rev * [B]
// d[B]/dt = k_rev * -[B] (rate of consumption of B)
// d[A]/dt = k_rev * [B] (rate of production of A)
