# What I would do differently

Notes about what I might do if I were to re-do Microvium from scratch.

## 32-bit

The first thing is that I would make it 32-bit, with a 32-bit slot size. This would:

1. Unlock much larger heap sizes.
2. Improve performance on 32-bit platforms. Especially related to address mapping.
3. Simplify a lot of the code and make it cleaner.

I think 16-bit was the right size to start with because it targets a niche and avoids making enemies in the 32-bit space, and because the RAM footprint is so incredibly low with a 16-bit slot size.

## No separate compile-time VM

I would consider just having one VM and use it at compile time or runtime.

## No "Futures" in the snapshot encoder

Rather do multiple passes. Futures are so hard to debug.

## No HTML output from snapshot encoder

Although it's helped a few times for debugging, it's not worth the complexity.