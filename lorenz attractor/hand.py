import cv2
import mediapipe as mp
from pythonosc import udp_client

# OSC client to send data to Processing
client = udp_client.SimpleUDPClient("127.0.0.1", 12000)

# MediaPipe Hands setup
mp_hands = mp.solutions.hands
mp_draw = mp.solutions.drawing_utils

# OpenCV setup
cap = cv2.VideoCapture(0)

# Hand gesture thresholds
FINGER_TIP_IDS = [4, 8, 12, 16, 20]

def detect_gesture(landmarks):
    thumb_tip = landmarks[4].y
    index_tip = landmarks[8].y
    middle_tip = landmarks[12].y
    ring_tip = landmarks[16].y
    pinky_tip = landmarks[20].y

    # Open palm gesture (Pause)
    if all(landmarks[i].y < landmarks[i - 2].y for i in FINGER_TIP_IDS):
        return "pause"
    
    # Index finger up (Speed up)
    elif index_tip < thumb_tip and index_tip < middle_tip:
        return "speed_up"
    
    # Two fingers up (Slow down)
    elif index_tip < thumb_tip and middle_tip < thumb_tip:
        return "slow_down"

    # Fist (Reset system)
    elif all(landmarks[i].y > landmarks[0].y for i in FINGER_TIP_IDS):
        return "reset"
    
    # Tilt hand left (Rotate Left)
    if landmarks[5].x < landmarks[17].x:
        return "rotate_left"

    # Tilt hand right (Rotate Right)
    elif landmarks[5].x > landmarks[17].x:
        return "rotate_right"

    return None

with mp_hands.Hands(min_detection_confidence=0.7, min_tracking_confidence=0.5) as hands:
    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break

        # Process frame and detect hands
        rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        result = hands.process(rgb_frame)

        if result.multi_hand_landmarks:
            for hand_landmarks in result.multi_hand_landmarks:
                mp_draw.draw_landmarks(frame, hand_landmarks, mp_hands.HAND_CONNECTIONS)

                gesture = detect_gesture(hand_landmarks.landmark)
                if gesture:
                    client.send_message("/gesture", gesture)

        # Show the frame
        cv2.imshow("Hand Control", frame)

        # Exit with 'q' key
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

cap.release()
cv2.destroyAllWindows()
