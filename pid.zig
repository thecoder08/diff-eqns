const print = @import("std").debug.print;

pub fn main() void {
    var speed: f32 = 0;
    const setSpeed: f32 = 1000;
    //const P = 1;
    const I = 1;
    const mass = 1;
    const deltaT = 0.00001;
    const k = 2; // drag/friction coefficient
    var errorIntegral: f32 = 0;
    while (true) {
        const err = setSpeed - speed; // error = SP - PV
        errorIntegral += err * deltaT;
        const force = I * errorIntegral - k * speed;
        speed += (force / mass) * deltaT;
        print("SP: {d}, PV: {d}\n", .{ setSpeed, speed });
    }
}
