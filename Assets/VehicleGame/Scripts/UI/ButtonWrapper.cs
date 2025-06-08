using System;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace Trell.Skyroads.UI
{
    [RequireComponent(typeof(Button))]
    public class ButtonWrapper : MonoBehaviour, IPointerDownHandler
    {
        private  Button _button;
        
        public event Action Clicked;
        public event Action Pressed;
        private void Awake()
        {
            _button = GetComponent<Button>();
        }

        private void OnEnable()
        {
            _button.onClick.AddListener(OnClicked);
        }

        private void OnDisable()
        {
            _button.onClick.RemoveListener(OnClicked);
        }

        public void Enable()
        {
            _button.interactable = true;
        }

        public void Disable()
        {
            _button.interactable = false;
        }

        public void OnPointerDown(PointerEventData eventData)
        {
            InvokePressLogic();
            Pressed?.Invoke();
        }

        protected virtual void InvokeClickLogic(){ }

        protected virtual void InvokePressLogic(){}

        private void OnClicked()
        {
            InvokeClickLogic();
            Clicked?.Invoke();
        }
    }
}