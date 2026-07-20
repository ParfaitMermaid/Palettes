clc;
clear;
close all;

%%%

addpath( genpath("MIMT") );
brush = zeros(64);
itmd = zeros(512, 24, 3); % Intermediate Color Map
coma = zeros(18, 25, 3); % Color Map
image = ones(18 * 64, 25 * 64, 3);

for b = 1 : 64
    for a = 1 : 64
        brush(b, a) = (a - 32.5) ^ 2 + (b - 32.5) ^ 2 <= 512;
    end
end

%%%

%

for iv = 0 : 255
    y = iv + 1;
    v = iv / 255;
    for ih = 0 : 23
        x = ih + 1;
        h = ih / 24;
        s = 1;
        itmd(y, x, :) = [h, s, v];
    end
end
for is = 0 : 255
    y = 512 - is;
    s = is / 255;
    for ih = 0 : 23
        x = ih + 1;
        h = ih / 24;
        v = 1;
        itmd(y, x, :) = [h, s, v];
    end
end
itmd = hsv2rgb(itmd);
itmd = rgb2lch(itmd, "luv");

%

for ih = 0 : 23
    is = 255;
    y = is + 1;
    x = ih + 1;
    y2 = 1;
    x2 = ih + 2;
    coma(y2, x2, :) = itmd(y, x, :);
end
for il = -8 : 8
    y = -il + 10;
    x = 1;
    l = 50 / 9 * (il + 9);
    coma(y, x, :) = [l, 0, 0];
end
for x2 = 2 : 25
    x = x2 - 1;
    il = 0;
    for il2 = -8 : 8
        y2 = -il2 + 10;
        l2 = 50 / 9 * (il2 + 9);
        while true
            y = il + 1;
            ny = y + 1;
            l = itmd(y, x, 1);
            nl = itmd(ny, x, 1);
            if nl < l2
                il = il + 1;
            else
                if nl - l2 < l2 - l
                    y = ny;
                end
                break;
            end
        end
        coma(y2, x2, :) = itmd(y, x, :);
    end
end

%

coma = lch2rgb(coma, "luv");
for y = 1 : 18
    for x = 1 : 25
        for b = 1 : 64
            for a = 1 : 64
                if brush(b, a)
                    image(b + 64 * (y - 1), a + 64 * (x - 1), :) = coma(y, x, :);
                end
            end
        end
    end
end

%

imshow(image);
imwrite(image, "Palette 2026.2 HL.png");