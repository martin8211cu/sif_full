function confirmAction(Msg, URL){
      res = confirm(Msg);
      if(res){
        window.document.location.replace(URL);
      }
      return 1;
}

function newWin(source,wid,hei){
       w=screen.width;
       h=screen.height;
       pos_x = 30;
       pos_y = 30;
       strFeatures="height="+hei+"; Width="+wid+"; channelmode=0; directories=0; fullscreen=0; location=1; menubar=1; scrollbars=1; status=1; toolbar=1; resizable=1; Top="+pos_y+"; left="+pos_x+";";
       retVal = window.open(source,"",strFeatures,true);
       return retVal;
}

function loadURL(URL){
        window.document.location.replace(URL);
        return 1;
}

function chksectionedit(sedit) {
        var reg1 = /(@.*@)|(\.\.)|(@\.)|(\.@)|(^\.)|( )/; 
        var reg2 = /^.+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,3}|[0-9]{1,3})(\]?)$/; 
        
        if (sedit.SNAME.value == "") {
        alert("Please do enter the Section Name");
        sedit.SNAME.focus();
        return false;
        }

return true;
}

function chkmemberedit(sedit) {
        var at = (sedit.EMAIL.value);
        var reg1 = /(@.*@)|(\.\.)|(@\.)|(\.@)|(^\.)|( )/; 
        var reg2 = /^.+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,3}|[0-9]{1,3})(\]?)$/; 
        if (sedit.NICKNAME.value == "") {
        alert("Please do enter your Nick Name");
        sedit.NICKNAME.focus();
        return false;
        }
        if (sedit.FIRSTNAME.value == "") {
        alert("Please do enter your First Name");
        sedit.FIRSTNAME.focus();
        return false;
        }
        if (sedit.LASTNAME1.value == "") {
        alert("Please do enter your Last Name");
        sedit.LASTNAME1.focus();
        return false;
        }
        if (sedit.PASSWORD1.value != sedit.PASSWORD2.value) {
        alert("Your passwords are not the same please try again");
        sedit.PASSWORD1.focus();
        return false;
        }
        if (!reg1.test(at) && reg2.test(at)) {
        return true;
        } else {
        alert(at + " is NOT an valid email address!");
        sedit.EMAIL.focus();
        return (false); 
        }

return true;
}

function formmailcheck(sedit) {
        if (sedit.SUBJECT.value == "") {
        alert("Please do enter the subject of email");
        sedit.SUBJECT.focus();
        return false;
        }
        if (sedit.MESSAGE.value == "") {
        alert("Please do enter the message");
        sedit.MESSAGE.focus();
        return false;
        }

return true;
}

function formcheck(sedit) {
        var at = (sedit.email.value);
        var reg1 = /(@.*@)|(\.\.)|(@\.)|(\.@)|(^\.)|( )/; 
        var reg2 = /^.+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,3}|[0-9]{1,3})(\]?)$/; 
        if (sedit.Name.value == "") {
        alert("Please do enter your Name");
        sedit.Name.focus();
        return false;
        }
        if (!reg1.test(at) && reg2.test(at)) {
        return true;
        } else {
        alert(at + " is NOT an valid email address!");
        sedit.email.focus();
        return (false); 
        }

return true;
}

function chkproductedit(sedit) {
        var reg1 = /(@.*@)|(\.\.)|(@\.)|(\.@)|(^\.)|( )/; 
        var reg2 = /^.+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,3}|[0-9]{1,3})(\]?)$/; 
        if (sedit.PNAME.value == "") {
        alert("Please do enter product's Name");
        sedit.PNAME.focus();
        return false;
        }
        if (sedit.PRODUCTID.value == "") {
        alert("Please do enter product ID");
        sedit.PRODUCTID.focus();
        return false;
        }
        if (sedit.WEIGHT.value == "") {
        alert("Please do enter product weight");
        sedit.WEIGHT.focus();
        return false;
        }
        if (sedit.PRICE.value == "") {
        alert("Please do enter product price");
        sedit.PRICE.focus();
        return false;
        }
        if (sedit.SALEPRICE.value == "") {
        alert("Please do enter product sale price");
        sedit.SALEPRICE.focus();
        return false;
        }

return true;
}

function chkpersonal(sedit) {
        var at = (sedit.EMAIL.value);
        var reg1 = /(@.*@)|(\.\.)|(@\.)|(\.@)|(^\.)|( )/; 
        var reg2 = /^.+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,3}|[0-9]{1,3})(\]?)$/; 
        if (sedit.FIRSTNAME.value == "") {
        alert("Please do enter your First Name");
        sedit.FIRSTNAME.focus();
        return false;
        }
        if (sedit.LASTNAME.value == "") {
        alert("Please do enter your Last Name");
        sedit.LASTNAME.focus();
        return false;
        }
        if (sedit.PASSWORD1.value != sedit.PASSWORD2.value) {
        alert("Your passwords are not the same please try again");
        sedit.PASSWORD1.focus();
        return false;
        }
        if (!reg1.test(at) && reg2.test(at)) {
        return true;
        } else {
        alert(at + " is NOT an valid email address!");
        sedit.EMAIL.focus();
        return (false); 
        }

return true;
}

function chkarticleedit(sedit) {
        var reg1 = /(@.*@)|(\.\.)|(@\.)|(\.@)|(^\.)|( )/; 
        var reg2 = /^.+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,3}|[0-9]{1,3})(\]?)$/; 
        if (sedit.TITLE.value == "") {
        alert("Please do enter the title of this article");
        sedit.TITLE.focus();
        return false;
        }
        if (sedit.AUTHOR.value == "") {
        alert("Please do enter the author of this article");
        sedit.AUTHOR.focus();
        return false;
        }

return true;
}

function chkcaseedit(sedit) {
        var reg1 = /(@.*@)|(\.\.)|(@\.)|(\.@)|(^\.)|( )/; 
        var reg2 = /^.+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,3}|[0-9]{1,3})(\]?)$/; 
        if (sedit.CASENUMBER.value == "") {
        alert("Please do enter the number of this case");
        sedit.TITLE.focus();
        return false;
        }
        if (sedit.CASETITLE.value == "") {
        alert("Please do enter the title of this case");
        sedit.TITLE.focus();
        return false;
        }
        if (sedit.AUTHOR.value == "") {
        alert("Please do enter the author of this case");
        sedit.AUTHOR.focus();
        return false;
        }

return true;
}

function chkissueedit(sedit) {
        var reg1 = /(@.*@)|(\.\.)|(@\.)|(\.@)|(^\.)|( )/; 
        var reg2 = /^.+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,3}|[0-9]{1,3})(\]?)$/; 
        if (sedit.TITLE.value == "") {
        alert("Please do enter the title of this issue");
        sedit.TITLE.focus();
        return false;
        }

return true;
}

function chkcategoryedit(sedit) {
        var reg1 = /(@.*@)|(\.\.)|(@\.)|(\.@)|(^\.)|( )/; 
        var reg2 = /^.+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,3}|[0-9]{1,3})(\]?)$/; 
        if (sedit.CNAME.value == "") {
        alert("Please do enter the name of this category");
        sedit.CNAME.focus();
        return false;
        }

return true;
}

function chkbannerzoneedit(sedit) {
        var reg1 = /(@.*@)|(\.\.)|(@\.)|(\.@)|(^\.)|( )/; 
        var reg2 = /^.+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,3}|[0-9]{1,3})(\]?)$/; 
        if (sedit.NAME.value == "") {
        alert("Please do enter the name of this banner zone");
        sedit.NAME.focus();
        return false;
        }
        if (sedit.BANNERSNUMBER.value == "") {
        alert("Please do enter the number of banners to show of this banner zone");
        sedit.BANNERSNUMBER.focus();
        return false;
        }
        if (sedit.PLACEHOLDER.value == "") {
        alert("Please do enter the placeholder of this banner zone");
        sedit.PLACEHOLDER.focus();
        return false;
        }

return true;
}

function showTime()
{

dayTwo = new Date();
dNow = dayTwo.getDate();
mNow = dayTwo.getMonth();
yNow = dayTwo.getYear();
hrNow = dayTwo.getHours();
mnNow = dayTwo.getMinutes();    
scNow = dayTwo.getSeconds();
miNow = dayTwo.getTime();

day = dNow;
month = mNow+1;
year = yNow;

if (hrNow == 0) 
    {
    hour = 0;
    ap = " AM";
    }

else if(hrNow <= 11) 
    {
    ap = " AM";
    hour = hrNow;
    } 

else if(hrNow == 12) 
    {
    ap = " PM";
    hour = 12;
    } 

else if (hrNow >= 13) 
    {
    hour = (hrNow - 12);
    ap = " PM";
    }

if (hrNow >= 13) 
    {
    hour = hrNow - 12;
    }

if (mnNow <= 9) 
    {
    min = "0" + mnNow;
    }

else (min = mnNow)
if (scNow <= 9) 
{
secs = "0" + scNow;
} 

else 
{
secs = scNow;
}
time = day + "." + month + "." + year + " " + hour + ":" + min + ":" + secs + " " + ap;

if(document.all){ document.all.clock.innerHTML=time;}

if(document.layers){
 document.clock.document.write('<p style=\"font-size:10px; font-weight:bold; font-family:Verdana; color:#a0a0a0;\">' + time + '<\/p>');
 document.clock.document.close();
}

setTimeout('showTime()', 1000);

}

function submit_search(keyw){
 document.msform.MSKEYWORD.value = keyw;
 document.msform.submit();
}
