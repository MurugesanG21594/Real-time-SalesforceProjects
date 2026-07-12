import { LightningElement } from 'lwc';
import AlarmClockAssets from '@salesforce/resourceUrl/AlarmClockAssets';

export default class AlarmClockApp extends LightningElement {
    clockImage = AlarmClockAssets + '/AlarmClockAssets/clock.png';
    ringtone = new Audio(AlarmClockAssets + '/AlarmClockAssets/Clocksound.mp3');
    currentTime = '';
    alarmHour = [];
    alarmMinutes = [];
    meridiams = ["AM","PM"];
    hourSelected;
    minSelected;
    meridiemSelected;
    alarmTime;
    isAlarmSet = false;
    alarmTriggered = false;

    get isAllAlarmFieldsSelected(){
        return !(this.hourSelected && this.minSelected && this.meridiemSelected);
    }
    get shakeImage(){
        return this.alarmTriggered ? 'shaking': '';
    }
    connectedCallback(){
        this.createHourOptions();
        this.createMinutesOptions();
        this.currentTimeHandler();
    }
    currentTimeHandler(){
        setInterval(() =>{
            let dateTime = new Date();
            let hour = dateTime.getHours();
            let minutes = dateTime.getMinutes();
            let seconds = dateTime.getSeconds();
            let ampm = 'AM';
            if(hour === 0){
                hour =12;
            }else if(hour === 12){
                ampm = 'PM';
            }else if(hour >= 12){
                hour = hour -12;
                ampm = 'PM';
            }
            hour = hour < 10 ? '0'+hour : hour;
            minutes = minutes < 10 ? '0'+minutes : minutes;
            seconds = seconds < 10 ? '0'+seconds : seconds;
            this.currentTime = `${hour}:${minutes}:${seconds} ${ampm}`;
            if(this.alarmTime === `${hour}:${minutes} ${ampm}`){
                this.alarmTriggered = true;
                this.ringtone.play();
                this.ringtone.loop = true;
            }
        },1000)       
    }
    createHourOptions(){
        for(let i=1; i <=12; i++ ){
            let val = i <10 ? '0'+i :i;
            this.alarmHour.push(val);
        }
    }
    createMinutesOptions(){
        for(let i=0; i <=59; i++ ){
            let val = i <10 ? '0'+i :i;
            this.alarmMinutes.push(val);
        }
    }

    optionHandler(event){
        const{label, value} = event.detail;
        if(label === 'Hour(s)'){
            this.hourSelected = value;
        }else if(label === 'Minutes(s)'){
            this.minSelected = value;
        }else if(label === 'AM/PM'){
            this.meridiemSelected = value;
        }else{

        }
    }
    setAlarmHandler(){
        this.alarmTime = `${this.hourSelected}:${this.minSelected} ${this.meridiemSelected}`;
        this.isAlarmSet = true;
    }
    clearAlarmHandler(){ 
        this.alarmTime ='';
        this.isAlarmSet = false;
        this.alarmTriggered = false;
        this.ringtone.pause();
        const elements = this.template.querySelectorAll('c-clock-drop-down');
        Array.from(elements).forEach(element =>{
            element.reset('')
        })
    }
}