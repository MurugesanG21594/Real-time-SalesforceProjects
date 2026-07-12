import { LightningElement, api} from 'lwc';

export default class ClockDropDown extends LightningElement {
    @api label = '';
    @api options = [];
    @api uniqueId = '';

    changeHandler(event){
        this.callParent(event.target.value);
    }

    callParent(value){
        const childCusEvent = new CustomEvent('optionhandler',{
            detail: {
                label: this.label,
                value: value
            }
        });
        this.dispatchEvent(childCusEvent);
    }
    @api
    reset(value){
        this.template.querySelector('select').value = value;
        this.callParent(value);
    }
}