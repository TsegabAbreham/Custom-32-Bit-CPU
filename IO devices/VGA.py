import pygame

WIDTH, HEIGHT = 64, 64
SCALE = 4

WINDOW = (WIDTH * SCALE, HEIGHT * SCALE)

class Framebuffer:
    def __init__(self):
        pygame.init()
        self.screen = pygame.display.set_mode(WINDOW)
        self.clock = pygame.time.Clock()
        self.pixels = [[(0, 0, 0) for _ in range(WIDTH)] for _ in range(HEIGHT)]

    def set_pixel(self, x, y, rgb):
        if 0 <= x < WIDTH and 0 <= y < HEIGHT:
            self.pixels[y][x] = rgb

    def draw(self):
        self.screen.fill((0, 0, 0))

        for y in range(HEIGHT):
            for x in range(WIDTH):
                color = self.pixels[y][x]

                pygame.draw.rect(
                    self.screen,
                    color,
                    (x * SCALE, y * SCALE, SCALE, SCALE)
                )

        pygame.display.flip()
        self.clock.tick(60)

    def run(self):
        running = True
        while running:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False

            self.draw()

        pygame.quit()


fb = Framebuffer()

# draw a few pixels
fb.set_pixel(10, 10, (255, 0, 0))   # red tile
fb.set_pixel(11, 10, (0, 255, 0))   # green tile
fb.set_pixel(12, 10, (0, 0, 255))   # blue tile

fb.run()