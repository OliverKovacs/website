blue = "#2472c8"
white = "#D4D4D4"

s = 14
f = (3/2) * abs(x - 1) - (5/4) * abs(x - 2) + (3/4) * abs(x - 4)
p = plot(f, (x,-1,6), transparent=True, color=blue)

p1 = (1, 1)
p2 = (2, 3)
p3 = (4, 2)

points = point2d([p1, p2, p3], color=blue)

botleft = dict(horizontal_alignment='left', vertical_alignment='bottom')
topleft = dict(horizontal_alignment='left', vertical_alignment='top')

tp1 = text(r'$P_1 = (1, 1)$', p1, **topleft, fontsize=s, color=blue)
tp2 = text(r'$P_2 = (2, 3)$', p2, **botleft, fontsize=s, color=blue)
tp3 = text(r'$P_3 = (4, 2)$', p3, **topleft, fontsize=s, color=blue)

p = p + points + tp1 + tp2 + tp3

p.axes_color(white)
p.axes_label_color(white)
p.tick_label_color(white)
p.save("tmp.svg")
