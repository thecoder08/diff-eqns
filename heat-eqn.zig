const xgfx = @cImport(@cInclude("xgfx/window.h"));
const drawing = @cImport(@cInclude("xgfx/drawing.h"));
const h: f32 = 0.0001;
const deltaTime = 0.000005;
var Ta: [640]f32 = undefined;
var T2: [640]f32 = undefined;
var frame: u32 = 0;

pub fn main() void {
    xgfx.initWindow(640, 480, "Heat Equation");
    // set up initial state of system
    for (0..640) |i| {
        const x: f32 = @as(f32, @floatFromInt(@as(i32, @intCast(i)) - 320)) / 100.0;
        Ta[i] = f(x);
    }
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
        for (0..640) |i| {
            T2[i] = f2Prime(i);
        }
        for (0..640) |i| {
            Ta[i] += T2[i] * deltaTime;
        }
        if (frame % 1000 == 0) {
            drawing.clear();
            for (0..640) |i| {
                //const x: f32 = @as(f32, @floatFromInt(@as(i32, @intCast(i)) - 320)) / 100.0;
                drawing.plot(@intCast(i), @as(i32, @intFromFloat(Ta[i] * -100)) + 240, 0x000000ff);
                drawing.plot(@intCast(i), @as(i32, @intFromFloat(f2Prime(i) * -100)) + 240, 0x0000ff00);
            }
            xgfx.updateWindow();
        }
        frame += 1;
    }
}

pub fn f(x: f32) f32 {
    return @exp(-(x + 1.5) * (x + 1.5)) + @exp(-(x - 1.5) * (x - 1.5));
}

pub fn f2Prime(x: usize) f32 {
    if (x < 1 or x > 638) {
        return 0;
    }
    return ((Ta[x + 1] - Ta[x]) - (Ta[x] - Ta[x - 1])) / h;
}
