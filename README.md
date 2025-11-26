# Cyberpunk 2077: Context-Aware Generative Texting

This project creates a bridge between **Cyberpunk 2077's internal game state** (Redscript engine) and **Large Language Models** (LLMs). While standard generative mods allow for generic conversation, this system injects real-time, high-fidelity context—Quest Objectives, Police Heat Levels, and Weather Conditions—into the LLM's system prompt, allowing companions to react dynamically to the player's immediate reality.


## The Difference: Context Matters

Standard LLM integration often feels disconnected from gameplay. This system fixes that by injecting the player's active Quest and current Objective into the prompt pipeline.

| **Standard Generative AI** | **Context-Aware System** |
| :---: | :---: |
| ![No Context](Images/NoContextMessage.png)<br>Witout quest context the character seems unaware of the world._ | ![With Context](Images/WithContextMessage.png)<br>With the quest "Riders on the Storm" being tracked the character knows the current state of the world._ |


## Features & Event Systems

### 1. Dynamic "Heat" Reactivity
The system hooks into the `PreventionSystem` to detect changes in police pursuit levels. It calculates a probability curve based on the threat level (1 Star = Low probability, 5 Stars = 100% probability) to trigger organic reactions.

| **Low Heat (Level 1)** | **Maximum Heat (Level 5)** |
| :---: | :---: |
| ![Heat Level 1](Images/PoliceEventHeatLvl1.png)<br>_Casual warning about minor trouble._ | ![Heat Level 5](Images/PoliceEventHeatLvl5.png)<br>_Urgent, high-stakes reaction._ |

