const xgfx = @cImport(@cInclude("xgfx/window.h"));
const drawing = @cImport(@cInclude("xgfx/drawing.h"));
const print = @import("std").debug.print;
const math = @import("std").math;

pub fn main() void {
    xgfx.initWindow(640, 480, "Rate of Reaction");
    var concA: f32 = 1; // initial concentration of reactant (A) (green)
    var concB: f32 = 0; // initial concentration of product (B) (blue)
    var oldConcA: f32 = 0;
    var oldConcB: f32 = 0;
    const deltaT = 0.01;
    const kFwd: f32 = 2; // rate constant of forward reaction (A to B)
    const kRev: f32 = 1; // rate constant of reverse reaction (B to A)
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
        oldConcA = concA;
        concA += -concA * deltaT * kFwd;
        concA += concB * deltaT * kRev;
        oldConcB = concB;
        concB += -concB * deltaT * kRev;
        concB += concA * deltaT * kFwd;

        drawing.line(x, 479 - @as(i32, @intFromFloat(oldConcA * 479)), x, 479 - @as(i32, @intFromFloat(concA * 479)), 0x0000ff00);
        drawing.line(x, 479 - @as(i32, @intFromFloat(oldConcB * 479)), x, 479 - @as(i32, @intFromFloat(concB * 479)), 0x000000ff);
        xgfx.updateWindow();
        x += 1;
        print("k_fwd/k_rev: {d}, concB/concA: {d}\n", .{ kFwd / kRev, concB / concA });
    }
}

// r_fwd = k_fwd * [A]
// d[A]/dt = k_fwd * -[A] (rate of consumption of A)
// d[B]/dt = k_fwd * [A] (rate of production of B)

// r_rev = k_rev * [B]
// d[B]/dt = k_rev * -[B] (rate of consumption of B)
// d[A]/dt = k_rev * [B] (rate of production of A)
