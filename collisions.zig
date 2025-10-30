const xgfx = @cImport(@cInclude("xgfx/window.h"));
const drawing = @cImport(@cInclude("xgfx/drawing.h"));
const body = struct { position: @Vector(3, f32), velocity: @Vector(3, f32), mass: f32 };
const print = @import("std").debug.print;

var a: body = .{ .position = .{ 100, 100, 0 }, .velocity = .{ 14, 10, 0 }, .mass = 1 };
var b: body = .{ .position = .{ 540, 380, 0 }, .velocity = .{ -14, -10, 0 }, .mass = 1 };
const deltaTime: f32 = 0.1;

pub fn main() void {
    xgfx.initWindow(640, 480, "Collisions");
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
        if (distance(a, b) < 40) {
            // calculate normal of collision
            var normal = b.position - a.position;
            normal /= @as(@Vector(3, f32), @splat(@sqrt(dotProduct(normal, normal))));
            print("normal of collision: {d} {d} {d}\n", .{ normal[0], normal[1], normal[2] });
            // project velocity onto normal
            //const avelocity = dotProduct(a.velocity, normal) / @sqrt(dotProduct(normal, normal));
            //const bvelocity = dotProduct(b.velocity, normal) / @sqrt(dotProduct(normal, normal));
            const avelocity = mulVectorMatrix(a.velocity, .{ normal, .{ -normal[1], normal[0], 0 }, .{ 0, 0, 0 } }); // velocity[0] - velocity parallel to normal. [1] - velocity perpendicular to normal.
            const bvelocity = mulVectorMatrix(b.velocity, .{ normal, .{ -normal[1], normal[0], 0 }, .{ 0, 0, 0 } });
            print("before: {d} {d}\n", .{ avelocity[0], bvelocity[0] });
            // calculate new velocities
            const aNewVelocity = (a.mass * avelocity[0] - b.mass * avelocity[0] + 2 * b.mass * bvelocity[0]) / (a.mass + b.mass);
            const bNewVelocity = (2 * a.mass * avelocity[0] - a.mass * bvelocity[0] + b.mass * bvelocity[0]) / (a.mass + b.mass);
            a.velocity = normal * @as(@Vector(3, f32), @splat(aNewVelocity)) + @as(@Vector(3, f32), .{ -normal[1], normal[0], 0 }) * @as(@Vector(3, f32), @splat(avelocity[1]));
            b.velocity = normal * @as(@Vector(3, f32), @splat(bNewVelocity)) + @as(@Vector(3, f32), .{ -normal[1], normal[0], 0 }) * @as(@Vector(3, f32), @splat(bvelocity[1]));
        }
        a.position += a.velocity * @as(@Vector(3, f32), @splat(deltaTime));
        b.position += b.velocity * @as(@Vector(3, f32), @splat(deltaTime));
        drawing.clear();
        drawing.circle(@intFromFloat(a.position[0]), @intFromFloat(a.position[1]), 20, 0x0000ff00);
        drawing.circle(@intFromFloat(b.position[0]), @intFromFloat(b.position[1]), 20, 0x000000ff);
        xgfx.updateWindow();
    }
}

fn distance(a1: body, b1: body) f32 {
    return @sqrt((a1.position[0] - b1.position[0]) * (a1.position[0] - b1.position[0]) + (a1.position[1] - b1.position[1]) * (a1.position[1] - b1.position[1]) + (a1.position[2] - b1.position[2]) * (a1.position[2] - b1.position[2]));
}

fn dotProduct(a1: @Vector(3, f32), b1: @Vector(3, f32)) f32 {
    const c = a1 * b1;
    return c[0] + c[1] + c[2];
}

fn mulVectorMatrix(v: @Vector(3, f32), m: [3]@Vector(3, f32)) @Vector(3, f32) {
    return .{ dotProduct(v, m[0]), dotProduct(v, m[1]), dotProduct(v, m[2]) };
}

//  and y =  and a (a + b)!=0 and b!=0
