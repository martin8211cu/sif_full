      function fnKeyPressNum(txtBox, e)
      {
        if (txtBox.type != "text")
          return true;

        var keycode;
        if (window.event)
          keycode = window.event.keyCode;
        else if (e)
          keycode = e.which;
        else
          return true;

        if (((keycode>47) && (keycode<58) ) || (keycode==8))
          return true;
        else if ((keycode==46) && (txtBox.value != "") &&
                 (txtBox.value.indexOf(".") == -1))
          return true;
        else
          return false;
      }
      function fnInputText(LprmTD)
      {
        if (LprmTD.hasChildNodes())
          for (var i=0; i<LprmTD.childNodes.length; i++)
            if (LprmTD.childNodes[i].nodeType == 1)
              return LprmTD.childNodes[i];
        return null;
      }
      function fnFormat(LprmValor,LprmDec,LprmPuntoDec)
      {
        var LvarValOriginal = LprmValor;
        var LvarSigno = 1;
        var LvarPunto = 0;
        var LvarCeros = 0;
        var i = 0;

        // AJUSTA PARAMETROS, PRIMERO LOS CONVIERTE A STRING, Y LUEGO PONE VALORES DEFAULT

        LprmValor += "";
        if( (LprmValor.length == 0) || (isNaN(parseFloat(LprmValor))) )
          LprmValor = 0;
        else
        {
          LprmValor = parseFloat(LprmValor);
          if(LprmValor < 0)
          {
            LvarSigno = -1;
            LprmValor = Math.abs(LprmValor);
          }
        }
        LprmDec += "";
        if((parseInt(LprmDec,10)) || (parseInt(LprmDec,10) == 0))
        {
          LprmDec = Math.abs(parseInt(LprmDec,10));
        }
        else
        {
          LprmDec = 0;
        }

		//var xx=false;
		//if (LprmValor>70.72 && LprmValor <70.73) {alert (LprmValor);xx=true;}

        LprmPuntoDec += "";
        if((LprmPuntoDec == "") || (LprmPuntoDec.length > 1))
          LprmPuntoDec = ".";

        // REDONDEA EL VALOR AL NUMERO DE DEC
        if (LprmDec == 0)
          LprmValor = "" + Math.round(LprmValor);
        else
          LprmValor = "" + Math.round(LprmValor * Math.pow(10,LprmDec)) / Math.pow(10,LprmDec);
        //if ((LprmValor.substring(1,2) == ".") || ((LprmValor + "")=="NaN"))
          //return(LvarValOriginal);

		//if (xx) alert (LprmValor);
		
        if (LprmDec > 0)
        {
          // RELLENA CON CEROS A LA DERECHA DEL PUNTO DECIMAL
          LvarPunto = LprmValor.indexOf(LprmPuntoDec);
          if (LvarPunto == -1)
          {
            LprmValor += LprmPuntoDec;
            LvarPunto = LprmValor.indexOf(LprmPuntoDec);
          }
          LvarCeros =  LprmDec - (LprmValor.length - LvarPunto - 1);
          for(i = 0; i < LvarCeros; i++)
            LprmValor += "0";
        }

        if(LvarSigno == -1)
          LprmValor = "-" + LprmValor;

        return(LprmValor);
      }
      function fnCambiarTD(LprmTD,LprmTexto,LprmNoPoner)
      {
	  	if (LprmTD == null) return;
		if (LprmNoPoner == true) 
		  LprmTexto="";
        var LvarTexto = document.createTextNode(LprmTexto);
		if (LprmTD.hasChildNodes())
        	LprmTD.replaceChild(LvarTexto,LprmTD.firstChild);
		else
			LprmTD.appendChild(LvarTexto);
      }
      function fnToDate(LprmFecha)
      {
        if (LprmFecha == "") 
          return "";
        var LvarPartes = LprmFecha.split ("/");
        return new Date(parseInt(LvarPartes[2], 10), parseInt(LvarPartes[1], 10)-1, parseInt(LvarPartes[0], 10));
      }
      function fnToDateYYYYMMDD(LprmFecha)
      {
        if (LprmFecha == "") 
          return "";
        var LvarPartes = LprmFecha.split ("/");
        return LvarPartes[2] + LvarPartes[1] + LvarPartes[0];
      }
      function fnVacio(LprmValor)
      {
		for (var i=0; i<LprmValor.length; i++)
		  if (LprmValor.substr(i,1) != " ")
		    return false;
		return true;
	  }
