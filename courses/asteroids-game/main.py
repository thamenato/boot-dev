import pygame

from constants import *
from player import Player


def main():
    print("Starting asteroids!")
    print(f"Screen width: {SCREEN_WIDTH}")
    print(f"Screen height: {SCREEN_HEIGHT}")

    pygame.init()

    pygame.display.set_caption("Asteroids")
    _window_size = (SCREEN_WIDTH, SCREEN_HEIGHT)
    screen = pygame.display.set_mode(_window_size)

    clock = pygame.time.Clock()
    dt = 0

    updatable = pygame.sprite.Group()
    drawable = pygame.sprite.Group()

    Player.containers = (updatable, drawable)

    is_running = True
    player = Player(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)

    while is_running:
        # poll for events
        # pygame.QUIT event means the user clicked X to close your window
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                is_running = False

        for u in updatable:
            u.update(dt)

        screen.fill("purple")

        for d in drawable:
            d.draw(screen)

        # player.draw(screen)
        # player.update(dt)

        # flip() the display to put your work on screen
        pygame.display.flip()

        dt = clock.tick(60) / 1000

    pygame.quit()


if __name__ == "__main__":
    main()
