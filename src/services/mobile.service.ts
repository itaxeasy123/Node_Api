import axios from 'axios';

export default class MobileService {
    static async sendotp(mobile:number,otp:string){
      console.log(mobile,otp)
        const options = {
            method: 'POST',
            url: 'https://control.msg91.com/api/v5/otp',
            params: {
              otp: otp,
              otp_expiry: '5',
              template_id: '646f44a2d6fc0508b4202fb2',
              mobile: `+91${mobile}`,
              authkey: '397428AfcZtnCU6784de09P1',
              realTimeResponse: '1'
            },
            headers: {'Content-Type': 'application/JSON'},
            data: '{\n  "Param1": "fsdfdsf",\n  "Param2": "dsfdsfds",\n  "Param3": "vdffsdf"\n}'
          };
          
          try {
            const { data } = await axios.request(options);
            console.log(data);
          } catch (error) {
            console.error(error);
          }
    }
    static async verifyotp(otp:string,mobile:number){
        const options = {
            method: 'GET',
            url: 'https://control.msg91.com/api/v5/otp/verify',
            params: {otp: otp, mobile: mobile},
            headers: {authkey: '397428Ak8UgZrWrY8646f0a52P1'}
          };
          
          try {
            const { data } = await axios.request(options);
            console.log(data);
          } catch (error) {
            console.error(error);
          }
}
static async resendotp(otp:string,mobile:number, retrytype:string){
    const options = {
        method: 'GET',
        url: 'https://control.msg91.com/api/v5/otp/retry',
        params: {
          authkey: '397428Ak8UgZrWrY8646f0a52P1',
          retrytype: retrytype,
          mobile: mobile,
        }
      };
      
      try {
        const { data } = await axios.request(options);
        console.log(data);
      } catch (error) {
        console.error(error);
      }
}
}