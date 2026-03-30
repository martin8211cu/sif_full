<!-- Establecimiento del modo -->
<cfif isdefined("url.Cambio") and len(trim(url.Cambio)) gt 0>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("url.modo")>
		<cfset modo="ALTA">
	<cfelseif url.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!-- modo para el detalle -->
<cfif isdefined("url.LPlinea")>
	<cfset dmodo="CAMBIO">
<cfelse>
	<cfif not isdefined("url.LPlinea")>
		<cfset dmodo="ALTA">
	<cfelseif url.dmodo EQ "CAMBIO">
		<cfset dmodo="CAMBIO">
	<cfelse>
		<cfset dmodo="ALTA">
	</cfif>
</cfif>

<cfinclude template="../../Utiles/sifConcat.cfm">

<!--- Consultas --->
<!--- 1. Form Encabezado --->
<cfquery name="rsArticulos" datasource="#session.DSN#">
	select a.Aid, a.Alm_Aid, c.Bdescripcion 
	from Existencias a, Articulos b, Almacen c
	where a.Aid=b.Aid
		and a.Alm_Aid=c.Aid 	
		and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	order by c.Bdescripcion
</cfquery> 

<cfquery name="rsExisteArticulo" datasource="#session.DSN#">	
	select convert(varchar,Aid)  #_Cat#'|'#_Cat# moneda as item 
	from DListaPrecios
	where LPtipo='A'
		and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		<cfif modo neq 'ALTA'>
			and LPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.LPid#"> 
			<cfif dmodo neq 'ALTA'>
				and LPlinea != <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.LPlinea#">
			</cfif>	
		</cfif>
</cfquery>	

<cfquery name="rsExisteConcepto" datasource="#session.DSN#">	
	select convert(varchar, Cid) #_Cat#'|'#_Cat# moneda as item
	from DListaPrecios
	where LPtipo='S'
		and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		<cfif modo neq 'ALTA'>
			and LPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.LPid#"> 
			<cfif dmodo neq 'ALTA'>
				and LPlinea != <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.LPlinea#"> 
			</cfif>
		</cfif>
</cfquery>
	
<cfquery datasource="#session.DSN#" name="rsmonedas">
	select Miso4217, Mnombre
	from Monedas
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	order by Mnombre
</cfquery>
	
<cfquery datasource="#session.DSN#" name="rsPais">
	select Ppais, Pnombre
	from Pais
	order by Pnombre
</cfquery>

<!--- Impuestos --->
<cfquery name="rsImpuestos" datasource="#Session.DSN#">
	select Icodigo, Idescripcion, Iporcentaje 
	from Impuestos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Idescripcion                                 
</cfquery>

<cfif modo neq "ALTA">
	<cfquery datasource="#session.DSN#" name="rsForm">
		select LPid , Ecodigo  ,LPdescripcion  ,LPdefault ,ts_rversion ,
			Pais, moneda, meses_financiamiento, BMUsucodigo, BMfechamod
		from EListaPrecios
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
  		  and LPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.LPid#">
	</cfquery>

	<!---
	<!--- Seccion del detalle --->
	<cfquery datasource="#session.DSN#" name="rsAlmacen">
		select Aid, Bdescripcion
		from Almacen
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		order by Bdescripcion
	</cfquery>
	--->

	<cfquery datasource="#session.DSN#" name="rsReferencia">
		select 1
		from EListaPrecios
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			and LPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.LPid#">
	</cfquery>
</cfif>	

<cfif modo neq 'ALTA' and dmodo neq 'ALTA'>
	<cfquery datasource="#session.DSN#" name="rsFormDetalle">
		select a.LPlinea ,a.LPid ,a.Ecodigo ,LPtipo ,Aid ,Cid ,Alm_Aid , a.moneda ,Icodigo ,DLdescripcion ,
		  DLfechaini ,DLfechafin ,DLprecio  , a.ts_rversion , precio_contado_vendedor ,precio_contado_supervisor,
		  precio_credito ,precio_credito_vendedor ,precio_credito_supervisor, prima_minima, comision_minimo, 
		  comision_excedente ,plazo_sugerido, plazo_maximo, interes_corriente , interes_mora, a.BMfechamod, a.BMUsucodigo,
		  b.Pais as Ppais
		from DListaPrecios a 
			inner join EListaPrecios b
			on a.Ecodigo = b.Ecodigo
			and a.LPid = b.LPid   
		where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		  and a.LPid    = <cfqueryparam value="#url.LPid#"    cfsqltype="cf_sql_numeric">
		  and LPlinea = <cfqueryparam value="#url.LPlinea#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	<cfquery name="rsDescripcion" datasource="#session.DSN#" >
		<cfif rsFormDetalle.LPtipo eq 'A'>
			select Adescripcion from Articulos where Aid = #rsFormDetalle.Aid#
		<cfelse>
			select Cdescripcion from Conceptos where Cid = #rsFormDetalle.Cid#
		</cfif>
	</cfquery>
	
</cfif>

<script language="JavaScript" type="text/JavaScript">
	// ==================================================================================================
	// 											Validaciones
	// ==================================================================================================
	function MM_findObj(n, d) { //v4.01
	  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
		d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	  if(!x && d.getElementById) x=d.getElementById(n); return x;
	}

	function MM_swapImgRestore() { //v3.0
	  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
	}
	
	function MM_swapImage() { //v3.0
	  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
	   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}
	
	function MM_validateForm() { //v4.0
	  var i,p,q,nm,test,num,min,max,errors='',args=MM_validateForm.arguments;
	  for (i=0; i<(args.length-2); i+=3) { test=args[i+2]; val=MM_findObj(args[i]);
		if (val) { if (val.alt!="") nm=val.alt; else nm=val.name; if ((val=val.value)!="") {
		  if (test.indexOf('isEmail')!=-1) { p=val.indexOf('@');
			if (p<1 || p==(val.length-1)) errors+='- '+nm+' no es una dirección de correo electrónica válida.\n';
		  } else if (test!='R') { num = parseFloat(qf(val));
			if (isNaN(qf(val))) errors+='- '+nm+' debe ser numérico.\n';
			if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
			  min=test.substring(8,p); //max=test.substring(p+1);
			  if (num<=min) errors+='- '+nm+' debe ser mayor a ' + min + '.\n';
		} } } else if (test.charAt(0) == 'R') errors += '- '+nm+' es requerido.\n'; }
	  } 
	  
	  if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
	  document.MM_returnValue = (errors == '');
	}

	var boton = "";
	function setBtn(obj){
		boton = obj.name;
	}
	
	function validar(){
		switch ( boton ) {
			case 'btnNuevoD' :
				return true;
				break;
	   		case 'btnBorrarE' :
	       		<cfif modo neq 'ALTA' and rsReferencia.RecordCount eq 0 >
		       		if ( confirm('Va a eliminar esta Lista de Precios y sus líneas de detalle. Desea continuar?') ){
			       		return true;
			   		}
				<cfelse>
					alert('La Lista de Precios no puede ser eliminada.');
					return false;
				</cfif>
		   		break;
	   		case 'btnBorrarD' :
				if ( confirm('Va a eliminar esta línea de detalle. Desea continuar?') ){
					return true;
				}
		   		break;
	   		case 'btnAgregarE' :
				MM_validateForm('LPdescripcion','','R','LPfechaini','','R','LPfechafin','','R');
				return document.MM_returnValue;
		   		break;

			// hay dos botones que hacen lo mismo (agregarD y cambiarD)
	   		default:
				if ( document.form1.LPtipo.value == 'A' ){
					MM_validateForm('LPdescripcion','','R','LPfechaini','','R','LPfechafin','','R','LPtipo','','R','Aid','','R', 'DLfechaini','','R','DLfechafin','','R', 'moneda', '', 'R', 'DLprecio','','R', 'DLprecio','','NinRange0:10' );
				}
				else{ 
					MM_validateForm('LPdescripcion','','R','LPfechaini','','R','LPfechafin','','R','LPtipo','','R','Cid','','R', 'DLfechaini','','R','DLfechafin','','R','moneda', '', 'R','DLprecio','','R', 'DLprecio','','NinRange0:10');
				}
			
				// solo para esta opcion, pues esta desactivado el combo en modo cambio 
				if ( boton == 'btnAgregarD' ){
					if (document.MM_returnValue ){
						document.form1.DLprecio.value = qf(document.form1.DLprecio.value)
						document.form1.precio_contado_vendedor.value = qf(document.form1.precio_contado_vendedor.value)
						document.form1.precio_contado_supervisor.value = qf(document.form1.precio_contado_supervisor.value)
						document.form1.precio_credito.value = qf(document.form1.precio_credito.value)
						document.form1.precio_credito_vendedor.value = qf(document.form1.precio_credito_vendedor.value)
						document.form1.precio_credito_supervisor.value = qf(document.form1.precio_credito_supervisor.value)
						document.form1.prima_minima.value = qf(document.form1.prima_minima.value)
						document.form1.comision_minimo.value = qf(document.form1.comision_minimo.value)
						document.form1.comision_excedente.value = qf(document.form1.comision_excedente.value)
						document.form1.interes_corriente.value = qf(document.form1.interes_corriente.value)
						document.form1.interes_mora.value = qf(document.form1.interes_mora.value)
					}
					return validaMontos();
				}

				// solo para esta opcion, pues esta desactivado el combo en modo cambio 
				if ( boton == 'btnCambiarD' ){
					if (document.MM_returnValue ){
						document.form1.LPtipo.disabled = false
						document.form1.DLprecio.value = qf(document.form1.DLprecio.value)
						document.form1.precio_contado_vendedor.value = qf(document.form1.precio_contado_vendedor.value)
						document.form1.precio_contado_supervisor.value = qf(document.form1.precio_contado_supervisor.value)
						document.form1.precio_credito.value = qf(document.form1.precio_credito.value)
						document.form1.precio_credito_vendedor.value = qf(document.form1.precio_credito_vendedor.value)
						document.form1.precio_credito_supervisor.value = qf(document.form1.precio_credito_supervisor.value)
						document.form1.prima_minima.value = qf(document.form1.prima_minima.value)
						document.form1.comision_minimo.value = qf(document.form1.comision_minimo.value)
						document.form1.comision_excedente.value = qf(document.form1.comision_excedente.value)
						document.form1.interes_corriente.value = qf(document.form1.interes_corriente.value)
						document.form1.interes_mora.value = qf(document.form1.interes_mora.value)
					}
					return validaMontos();
				}
				return document.MM_returnValue;
		    	break;
		}
		return false;
	}


	function cambiar_tipo( tipo, origen ) {
		// limpia los campos dinamicos, todos. Solo cuando los llama del combo
		if ( origen == 'c' ){
			document.form1.Aid.value = '';
			document.form1.Cid.value = '';
			document.form1.Cdescripcion.value = '';	
		}	

		// muestra la opcion seleccionada
		var valor = new String(tipo).toUpperCase()
		var div_a = document.getElementById("divA");
		//var div_a2   = document.getElementById("divA2");
		var div_ae  = document.getElementById("divAe");
		var div_ae2 = document.getElementById("divAe2");
		var div_s   = document.getElementById("divS");
		var div_se  = document.getElementById("divSe");
	
		switch ( valor ) {
	   		case 'A' :
				div_a.style.display  = '' ;
		   		//div_a2.style.display = '' ;
		   		div_ae.style.display = '' ;		   		   
		   		div_s.style.display  = 'none' ;
		   		div_se.style.display = 'none' ;
		   		//div_ae2.style.display = '' ;
		  	 	break;
	   		
			case 'S' :
		   		div_a.style.display  = 'none' ;
		   		//div_a2.style.display = 'none' ;
		   		div_ae.style.display = 'none' ;
		   		div_s.style.display  = '' ;
		   		div_se.style.display = '' ;
		   		//div_ae2.style.display = 'none' ;
		   		break;
	   
	   		default :
		   		div_a.style.display  = '' ;
		   		//div_a2.style.display = '' ;
		   		div_ae.style.display = '' ;
		   		div_s.style.display  = 'none' ;
		   		div_se.style.display = 'none' ;
		   		//div_ae2.style.display = 'none' ;
		}
		return;
	}

	// ===========================================================================================
	//								Conlis de Servicios, Articulos
	// ===========================================================================================
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin) {
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis() {
		popUpWindow("ConlisConceptos.cfm?form=form1&id=Cid&desc=Cdescripcion" ,250,200,650,350);
	}
	
	function doConlisArt() {
		popUpWindow("ConlisArticulos.cfm?form=form1&id=Aid&desc=Adescripcion" ,250,200,650,350);
	}
	// ===========================================================================================

	function valida_rango( _this,dec ){
		var numero = new Number(qf(_this.value));
		
		if (numero == 0 && _this.value != ''){
			alert('El Rango no puede ser 0.00');
			_this.value = '';
			_this.focus();
			return
		}
		
		if( _this.value != '' ){
			fm(_this,dec);
		}
	}
	
	function valida_monto(_this){
 		var numero = new Number(qf(_this.value));
		
		if (numero >= 1000 && _this.value != ''){
			alert('El monto no puede ser mayor de 999.99');
			_this.value = '';
			_this.focus();
			return
		}
	}
	
	function valida_interes(_this){
 		var numero = new Number(qf(_this.value));
		if (numero >= 100 && _this.value != ''){
			alert('El monto no puede ser mayor de 99.99');
			_this.value = '';
			_this.focus();
			return
		}
	}
	
	function valida_mayor(_this,otro, desc1, desc2){
 		var numero1 = new Number(qf(_this.value));
		var numero2 = new Number(qf(otro));
		if ( numero1 != 0 && numero2 != 0 && numero1 < numero2){
			alert('El ' + desc1 + ' no puede ser menor que el ' + desc2);
			//_this.value = '';
			_this.focus();
			return
		}
	}
	
	function valida_menor(_this,otro, desc1, desc2){
 		var numero1 = new Number(qf(_this.value));
		var numero2 = new Number(qf(otro));
		if (numero1 != 0 && numero2 != 0 && numero1 > numero2 ){
			alert('El ' + desc1 +' no puede ser mayor que el ' + desc2);
			//_this.value = '';
			_this.focus();
			return
		}
	}
	
	function validaMontos(){
		var Con_Cliente = new Number(qf(document.form1.DLprecio.value));
		var Cre_Cliente = new Number(qf(document.form1.precio_credito.value));
		
		var Con_Vendedor= new Number(qf(document.form1.precio_contado_vendedor.value));
		var Cre_Vendedor = new Number(qf(document.form1.precio_credito_vendedor.value));
		
		var Con_Supervisor= new Number(qf(document.form1.precio_contado_supervisor.value));
		var Cre_Supervisor = new Number(qf(document.form1.precio_credito_supervisor.value));
		
		//Validaciones Precio Contado
		if (Con_Cliente != 0 && Con_Vendedor != 0 && Con_Vendedor > Con_Cliente ){
			alert('El Precio de Contado del Vendedor no puede ser mayor que el Precio al Cliente');
			return false
		}
		
		if (Con_Supervisor != 0 && Con_Vendedor != 0 && Con_Supervisor > Con_Vendedor ){
			alert('El Precio de Contado del Supervisor no puede ser mayor que el Precio de contado del Vendedor');
			return false
		}
		
		if (Con_Cliente != 0 && Cre_Cliente != 0 && Con_Cliente > Cre_Cliente ){
			alert('El Precio de Contado del Cliente no puede ser mayor que el Precio a Crédito del Cliente');
			return false
		}
		
		if (Con_Vendedor != 0 && Cre_Vendedor != 0 && Con_Vendedor > Cre_Vendedor    ){
			alert('El Precio al Contado del Vendedor no puede ser menor que el Precio al Crédito del Vendedor ');
			return false
		}
		if (Con_Supervisor != 0 && Cre_Supervisor != 0 && Con_Supervisor > Cre_Supervisor    ){
			alert('El Precio al Contado del Supervisor  no puede ser mayor que el Precio al Crédito del Supervisor ');
			return false
		}
		//Validaciones Precio Crédito
		if (Cre_Cliente != 0 && Cre_Vendedor != 0 && Cre_Vendedor > Cre_Cliente ){
			alert('El Precio de Crédito del Vendedor no puede ser mayor que el Precio de Crédito al Cliente');
			return false
		}
		
		if (Cre_Supervisor != 0 && Cre_Vendedor != 0 && Cre_Supervisor > Cre_Vendedor ){
			alert('El Precio de Crédito del Supervisor no puede ser mayor que el Precio de Crédito del Vendedor');
			return false
		}
	}
	
	function paquetes(){
		document.form1.action = "Paquetes.cfm"
		document.form1.submit();
	}

	function cambia_articulo(articulo, almacen){
		i = 0;
		/*document.form1.Alm_Aid.length = 0;
		i = 0;
		<cfoutput query="rsArticulos">
			if ( #Trim(rsArticulos.Aid)# == articulo ){
				document.form1.Alm_Aid.length = i+1;
				document.form1.Alm_Aid.options[i].value = '#rsArticulos.Alm_Aid#';
				document.form1.Alm_Aid.options[i].text  = '#rsArticulos.Bdescripcion#';

				if ( almacen == #Trim(rsArticulos.Alm_Aid)# ){
					document.form1.Alm_Aid.options[i].selected=true;
				}
				i++;
			};
		</cfoutput>
		*/
	}
	

	function existe(){
	// RESULTADO
	// Valida que la combinacion articulo|moneda ó concepto|moneda, no exista para la lista de precios
	
		var linea   = "" 
		var lineabd = ""

		// articulos
		if ( document.form1.LPtipo.value == 'A' ){
			if (trim(document.form1.Aid.value) != "" || trim(document.form1.moneda.value) != "" ){
				linea =  trim(document.form1.Aid.value) + '|' + trim(document.form1.moneda.value);
				<cfoutput query="rsExisteArticulo">
					lineabd = '#Trim(rsExisteArticulo.item)#'
					if ( linea == lineabd ) {
						alert('El Artículo y Moneda que desea agregar ya existe.');
						document.form1.Aid.value          = ""
						document.form1.Adescripcion.value = ""
					}
				</cfoutput>
			}
		}
		// servicios
		else{
			if (trim(document.form1.Cid.value) != "" || trim(document.form1.moneda.value) != "" ){
				linea =  trim(document.form1.Cid.value) + '|' + trim(document.form1.moneda.value);
				<cfoutput query="rsExisteConcepto">
					lineabd = '#rsExisteConcepto.item#'
					if ( linea == lineabd ) {
						alert('El Concepto y Moneda que desea agregar, ya existe. ');
						document.form1.Cid.value          = ""
						document.form1.Cdescripcion.value = ""
					}
				</cfoutput>
			}
		}
		return true
	}

</script>

<script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>



<form action= "SQLListaPrecios.cfm" method="post" name="form1" onSubmit="return validar();  " >

	<cfoutput>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center" >
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center" >
					<tr><td class="tituloAlterno" colspan="6">Encabezado de Lista de Precios</td></tr>
					
					<tr>
						<td width="24%" align="right" nowrap >Lista de Precios:&nbsp;</td>
						<td width="35%" nowrap><input type="text" name="LPdescripcion" size="50" maxlength="80"  tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.LPdescripcion#</cfif>" onfocus="javascript:this.select();"  ></td>
						<td align="right" nowrap>Pais:</td>
						<td><select name="Pais" id="Pais" tabindex="2">
                            <cfloop query="rsPais">
                              <option value="#rsPais.Ppais#" <cfif isdefined("rsForm") and rsForm.Pais EQ rsPais.Ppais>selected</cfif>>#HTMLEditFormat(rsPais.Pnombre)#</option>
                            </cfloop>
                        </select></td>
						<td width="10%" align="right" nowrap >&nbsp;</td>
						<td width="13%" nowrap>&nbsp;</td>
					</tr>
					<tr>
					  <td align="right">Moneda:&nbsp;</td>
					  <td>
                        <table border="0" width="100%">
                          <tr>
                            <td>
                              <!---<cfif dmodo neq 'ALTA'>	
												<cf_sifmonedas query="#rsFormDetalle#" onChange="existe()" >
											<cfelse>
												<cf_sifmonedas onChange="existe()">
											</cfif>	
											<script language="JavaScript1.2" type="text/javascript">
												document.form1.moneda.alt = "La Moneda"
											</script> --->
                              <select name="moneda" id="moneda" tabindex="3">
                                <cfloop query="rsmonedas">
                                  <option value="#rsmonedas.Miso4217#" <cfif isdefined("rsForm") and rsForm.moneda EQ rsmonedas.Miso4217>selected</cfif>>#HTMLEditFormat(rsmonedas.Mnombre)#</option>
                                </cfloop>
                              </select>
                            </td>
                          </tr>
                      </table></td>
					  <td align="right" nowrap>Meses Financiamiento </td>
					  <td><input type="text" name="meses_financiamiento"  tabindex="4"value="<cfif modo neq "ALTA" and len(trim(rsForm.meses_financiamiento)) gt 0 >#rsForm.meses_financiamiento#</cfif>"   size="20" maxlength="20" style="text-align: right;" onblur="javascript: valida_rango(this,0); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" alt="Los Meses de Financiamiento" ></td>
					  <td align="right" nowrap >&nbsp;</td>
					  <td nowrap>&nbsp;</td>
				  </tr>

					<cfset ts = "">	
					<cfif modo neq "ALTA">
						<cfinvoke 
							component="sif.Componentes.DButils"
							method="toTimeStamp"
							returnvariable="ts">
							<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
						</cfinvoke>
					</cfif>
			
					<!--- CAMPOS OCULTOS--->
					<tr>
						<td colspan="3"><input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'>#ts#</cfif>"></td>
						<td colspan="3"><input type="hidden" name="LPid"      value="<cfif modo NEQ 'ALTA'>#url.LPid#</cfif>"></td>
					</tr>
			  </table>	
			</td>	
		</tr>
		
		<!-- ============================================================================================================ -->
		<!-- Seccion del detalle -->
		<!-- Solo se pinta si estamos en el modo cambio del encabezado -->
		<!-- ============================================================================================================ -->		

		<cfif modo NEQ 'ALTA'>
			<tr><td>&nbsp;</td></tr>
			<tr><td class="tituloAlterno">Detalle de Lista de Precios</td></tr>
				<tr>
				<td align="center" > 
					<table width="85%" border="0" cellpadding="0" cellspacing="0" >
						<!--- Linea que pinta el tipo de Compra, servicios/articulos --->
						<tr>
							<td align="right">Tipo:&nbsp;</td>
							<td nowrap>
								<select name="LPtipo" onChange="javascript:cambiar_tipo(this.value, 'c');"  tabindex="5" <cfif dmodo neq 'ALTA'>disabled</cfif> >
									<option value="A" <cfif dmodo neq 'ALTA'><cfif rsFormDetalle.LPtipo eq 'A'>selected</cfif></cfif> >Artículos</option>
									<option value="S" <cfif dmodo neq 'ALTA'><cfif rsFormDetalle.LPtipo eq 'S'>selected</cfif></cfif> >Conceptos</option>
								</select>
							</td>
							
							<td align="right">
								<div id="divAe" style="display: none ;" >Art&iacute;culo:&nbsp;</div>
								<div id="divSe" style="display: none ;" >Concepto:&nbsp;</div>
							</td>
								
							<td nowrap width="25%" >
								<div id="divS" style="display: none ;" >
									<input name="Cdescripcion" disabled type="text" value="<cfif dmodo NEQ "ALTA" and #rsFormDetalle.LPtipo# eq "S" >#rsDescripcion.Cdescripcion#</cfif>" size="60" maxlength="50"> 
									<a href="##">
										<img src="../../imagenes/Description.gif" alt="Lista de Conceptos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlis();">
									</a> 
									<input type="hidden" name="Cid" value="<cfif dmodo NEQ "ALTA"><cfoutput>#rsFormDetalle.Cid#</cfoutput></cfif>" alt="El Concepto">
								</div>						
		
								<div id="divA" style="display: none ;" >
									<input name="Adescripcion" disabled type="text" value="<cfif dmodo NEQ "ALTA" and #rsFormDetalle.LPtipo# eq "A">#rsDescripcion.Adescripcion#</cfif>" size="60" maxlength="80">
									<a href="##">
										<img src="../../imagenes/Description.gif" alt="Lista de Art&iacute;culos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisArt();">
									</a> 
									<input type="hidden" name="Aid" value="<cfif dmodo NEQ "ALTA"><cfoutput>#rsFormDetalle.Aid#</cfoutput></cfif>" alt="El Art&iacute;culo">
								</div>
							</td>	
						</tr>
		
						<!--- Activos/Almacen --->
						<tr>
							<td align="right" nowrap >Descripci&oacute;n:&nbsp;</td>
							<td nowrap id="prueba"><input type="text" name="DLdescripcion" tabindex="6" size="50" maxlength="255" value="<cfif dmodo neq 'ALTA'>#rsFormDetalle.DLdescripcion#</cfif>" onfocus="javascript:this.select();" ></td>

							<td align="right">Moneda:</td>
							<td>
                              <table border="0" width="100%">
                                <tr>
                                  <td align="right">
                                    <div align="left">
                                      <select name="Dmoneda" id="Dmoneda" tabindex="7">
                                        <cfloop query="rsmonedas">
                                          <option value="#rsmonedas.Miso4217#" <cfif isdefined("rsFormDetalle") and rsFormDetalle.moneda EQ rsmonedas.Miso4217>selected<cfelseif isdefined("rsForm") and rsForm.moneda EQ rsmonedas.Miso4217>selected</cfif>>#HTMLEditFormat(rsmonedas.Mnombre)#</option>
                                        </cfloop>
                                      </select>
                                    </div></td>
                                </tr>
                            </table></td>
						</tr>
						
						<tr>
                          <td align="right">Impuesto:</td>
                          <td><select name="Icodigo" tabindex="8" >
                              <option value="#rsImpuestos.Icodigo#" <cfif isdefined("rsFormDetalle") and rsImpuestos.Icodigo EQ rsFormDetalle.Icodigo>selected</cfif>>#rsImpuestos.Idescripcion#</option>
                          </select></td>
                          <td valign="baseline" align="right" >
                            <!---<div id="divAe2" style="display: none ;" > Almac&eacute;n:&nbsp; </div></td> --->
                          <td nowrap>
						  	<!---
                            <div id="divA2" style="display: none;">
                              <select name="Alm_Aid" >
                                <cfloop query="rsAlmacen">
                                  <cfif dmodo EQ 'ALTA'>
                                    <option value="#rsAlmacen.Aid#">#rsAlmacen.Bdescripcion#</option>
                                    <cfelse>
                                    <option value="#rsAlmacen.Aid#" <cfif #rsFormDetalle.Alm_Aid# EQ #rsAlmacen.Aid#>selected</cfif> >#rsAlmacen.Bdescripcion#</option>
                                  </cfif>
                                </cfloop>
                              </select>
                          </div> --->
						  &nbsp;
						  </td>
					  </tr>
						<tr>
							<td nowrap align="right" >Fecha Inicial:&nbsp;</td>
	
							<cfif dmodo neq 'ALTA'>
								<cfset fechai = LSDateFormat(rsFormDetalle.DLfechaini, 'dd/mm/yyyy')>
								<cfset fechaf = LSDateFormat(rsFormDetalle.DLfechafin, 'dd/mm/yyyy')>
							<cfelse>
								<cfset fechai = LSDateFormat(Now(), 'dd/mm/yyyy') >
								<cfset fechaf = LSDateFormat(DateAdd("d",30,Now()), 'dd/mm/yyyy') >
							</cfif>
							<td nowrap><cf_sifcalendario Conexion="#session.DSN#" form="form1" name="DLfechaini" value="#fechai#" tabindex="9" ></td>
							<td nowrap align="right" >Fecha Final:&nbsp;</td>
							<td nowrap><cf_sifcalendario Conexion="#session.DSN#" form="form1" name="DLfechafin" value="#fechaf#" tabindex="10"></td>
						</tr>
						
						<!--- Activos/Almacen --->
						
						<tr>
						  <td align="right" class="tituloAlterno">Precio:</td>
						  <td class="tituloAlterno">&nbsp;</td>
						  <td align="right" class="tituloAlterno">Financiamiento:</td>
						  <td class="tituloAlterno">&nbsp;</td>
					  </tr>
						<tr>
						  <td align="right"><em><strong>Contado</strong></em></td>
						  <td>&nbsp;</td>
						  <td align="right" nowrap>&nbsp;</td>
						  <td>&nbsp;</td>
					  </tr>
						<tr>
						  <td align="right">  Cliente:&nbsp;</td>
						  <td>
                            <input type="text" name="DLprecio"  tabindex="10" value="<cfif dmodo NEQ 'ALTA'><cfoutput>#LSCurrencyFormat(rsFormDetalle.DLprecio, 'none')#</cfoutput><cfelse>0.00</cfif>" size="20" maxlength="20" style="text-align: right;" onblur="javascript: fm(this,2);  " onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El Precio" >
                          </td>
						  <td align="right" nowrap><div align="right">Prima M&iacute;nima:</div></td>
						  <td><input type="text" name="prima_minima"  tabindex="18" value="<cfif dmodo NEQ 'ALTA' and len(trim(rsFormDetalle.prima_minima)) gt 0 >#LSCurrencyFormat(rsFormDetalle.prima_minima, 'none')#<cfelse>0.00</cfif>"   size="20" maxlength="20" style="text-align: right;" onblur="javascript: valida_rango(this,2);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="La prima M&iacute;nima" ></td>
					  </tr>
						<tr>
						  <td align="right" nowrap><div align="right">Autorizado Vendedor:</div></td>
						  <td><input type="text" name="precio_contado_vendedor"  tabindex="11" value="<cfif dmodo NEQ 'ALTA' and len(trim(rsFormDetalle.precio_contado_vendedor)) gt 0 >#LSCurrencyFormat(rsFormDetalle.precio_contado_vendedor, 'none')#<cfelse>0.00</cfif>"   size="20" maxlength="20" style="text-align: right;" onblur="javascript: valida_rango(this,2);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El Precio al contado del Vendedor" ></td>
						  <td align="right" nowrap><div align="right">Plazo Sugerido:</div></td>
						  <td><input type="text" name="plazo_sugerido" tabindex="19" value="<cfif dmodo NEQ 'ALTA' and len(trim(rsFormDetalle.plazo_sugerido)) gt 0 >#rsFormDetalle.plazo_sugerido#<cfelse>0</cfif>"   size="20" maxlength="20" style="text-align: right;" onblur="javascript: valida_rango(this,0); valida_menor(this,document.form1.plazo_maximo,'Plazo Sugerido','Plazo M&aacute;ximo');"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" alt="El Plazo sugerido" >
  meses</td>
					  </tr>
						<tr>
						  <td align="right" nowrap><div align="right">Autorizado Supervisor:</div></td>
						  <td><input type="text" name="precio_contado_supervisor"  tabindex="12" value="<cfif dmodo NEQ 'ALTA' and len(trim(rsFormDetalle.precio_contado_supervisor)) gt 0 >#LSCurrencyFormat(rsFormDetalle.precio_contado_supervisor, 'none')#<cfelse>0.00</cfif>"   size="20" maxlength="20" style="text-align: right;" onblur="javascript: valida_rango(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El Precio al contado del Supervisor" ></td>
						  <td align="right" nowrap><div align="right">Plazo M&aacute;ximo:</div></td>
						  <td><input type="text" name="plazo_maximo"  tabindex="20" value="<cfif dmodo NEQ 'ALTA' and len(trim(rsFormDetalle.plazo_maximo)) gt 0 >#rsFormDetalle.plazo_maximo#<cfelse>0</cfif>"   size="20" maxlength="20" style="text-align: right;" onblur="javascript: valida_rango(this,0); valida_mayor(this,document.form1.plazo_sugerido,'Plazo M&aacute;ximo', 'Plazo Sugerido');"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" alt="El Plazo M&aacute;ximo" >
  meses</td>
					  </tr>
						<tr>
						  <td align="right"><em><strong>Cr&eacute;dito</strong></em></td>
						  <td>&nbsp;</td>
						  <td align="right" nowrap><em><strong>Inter&eacute;s</strong></em></td>
						  <td>&nbsp;</td>
					  </tr>
						<tr>
						  <td align="right" nowrap><div align="right">Cliente:&nbsp;</div></td>
						  <td><input type="text" name="precio_credito" tabindex="13" value="<cfif dmodo NEQ 'ALTA' and len(trim(rsFormDetalle.precio_credito)) gt 0 ><cfoutput>#LSCurrencyFormat(rsFormDetalle.precio_credito, 'none')#</cfoutput><cfelse>0.00</cfif>"   size="20" maxlength="20" style="text-align: right;" onblur="javascript: valida_rango(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El Precio al Cr&eacute;dito" >
                          </td>
						  <td align="right" nowrap><div align="right">Inter&eacute;s Corriente:</div></td>
						  <td>
						  	<input type="text" name="interes_corriente" tabindex="21" value="<cfif dmodo NEQ 'ALTA' and len(trim(rsFormDetalle.interes_corriente)) gt 0 >#LSCurrencyFormat(rsFormDetalle.interes_corriente, 'none')#<cfelse>0.00</cfif>" size="20" maxlength="20" style="text-align: right;" onblur="javascript: valida_rango(this,2);" onfocus="javascript:this.value=qf(this); this.select();" onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El Inter&eacute;s corriente" > 
  							% anual 
						</td>
						<!--- onblur="javascript: valida_interes(this); valida_monto(this); valida_menor(this,document.form1.interes_mora,'Inter&eacute;s Corriente','Inter&eacute;s Moratorio'); valida_rango(this,2);"  --->

					  </tr>
						<tr>
						  <td align="right" nowrap><div align="right">Autorizado  Vendedor:</div></td>
						  <td><input type="text" name="precio_credito_vendedor"  tabindex="14" value="<cfif dmodo NEQ 'ALTA' and len(trim(rsFormDetalle.precio_credito_vendedor)) gt 0 >#LSCurrencyFormat(rsFormDetalle.precio_credito_vendedor, 'none')#<cfelse>0.00</cfif>"  size="20" maxlength="20" style="text-align: right;"  onBlur="javascript: valida_rango(this,2); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El Precio al cr&eacute;dito del vendedor" ></td>
						  <td align="right" nowrap><div align="right">Inter&eacute;s Mora:</div></td>
						  <td>
						  	<input type="text"  
						  		name="interes_mora" 
								tabindex="22" 
								value="<cfif dmodo NEQ 'ALTA' and len(trim(rsFormDetalle.interes_mora)) gt 0 >#LSCurrencyFormat(rsFormDetalle.interes_mora, 'none')#<cfelse>0.00</cfif>"   
								size="20"  
								maxlength="10" 
								style="text-align: right;" 
								onblur="javascript: valida_rango(this,2);"  
								onfocus="javascript:this.value=qf(this); this.select();"  
								onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
								alt="El Inter&eacute;s Mora" >
  							% anual 
						</td>
								<!--- onblur="javascript: valida_interes(this); valida_monto(this); valida_mayor(this,document.form1.interes_corriente,'Inter&eacute;s Moratorio', 'Inter&eacute;s Corriente'); valida_rango(this,2);"  --->
					  </tr>
						<tr>
						  <td align="right" nowrap><div align="right"> Autorizado  Supervisor:</div></td>
						  <td><input type="text" name="precio_credito_supervisor"  tabindex="15" value="<cfif dmodo NEQ 'ALTA' and len(trim(rsFormDetalle.precio_credito_supervisor)) gt 0 >#LSCurrencyFormat(rsFormDetalle.precio_credito_supervisor, 'none')#<cfelse>0.00</cfif>"   size="20" maxlength="20" style="text-align: right;" onblur="javascript: valida_rango(this,2);  "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El Precio al cr&eacute;dito del Supervisor" ></td>
						  <td align="right" nowrap>&nbsp;</td>
						  <td>&nbsp;</td>
					  </tr>
						<tr>
						  <td align="right" class="tituloAlterno">Comisiones:</td>
						  <td class="tituloAlterno">&nbsp;</td>
						  <td align="right" class="tituloAlterno">&nbsp;</td>
						  <td class="tituloAlterno">&nbsp;</td>
					  </tr>
						<tr>
						  <td align="right" nowrap><div align="right">Sobre el precio m&iacute;nimo:</div></td>
						  <td><input type="text" name="comision_minimo" tabindex="16" value="<cfif dmodo NEQ 'ALTA' and len(trim(rsFormDetalle.comision_minimo)) gt 0 >#LSCurrencyFormat(rsFormDetalle.comision_minimo, 'none')#<cfelse>0.00</cfif>"  size="20" maxlength="20" style="text-align: right;"  onblur="javascript: valida_interes(this); valida_rango(this,2); valida_monto(this); valida_menor(this,document.form1.comision_excedente,'Precio M&iacute;nimo','Excedente');"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="La comision M&iacute;nima" >
						    %</td>
                          <td align="right" nowrap>&nbsp;</td>
                          <td>&nbsp;</td>
					  </tr>
						<tr>
						  <td align="right" nowrap><div align="right">Sobre el excedente:</div></td>
						  <td><input type="text" name="comision_excedente"  tabindex="17" value="<cfif dmodo NEQ 'ALTA' and len(trim(rsFormDetalle.comision_excedente)) gt 0 >#LSCurrencyFormat(rsFormDetalle.comision_excedente, 'none')#<cfelse>0.00</cfif>"   size="20" maxlength="20" style="text-align: right;" onblur="javascript: valida_interes(this); valida_rango(this,2); valida_monto(this); valida_mayor(this,document.form1.comision_minimo,'Excedente', 'Precio M&iacute;nimo');"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="Comisi&oacute;n Excedente" >
						    %</td>
						  <td align="right" nowrap>&nbsp;</td>
						  <td>&nbsp;</td>
					  </tr>
					  
						<tr>
						  <td align="right" nowrap>&nbsp;</td>
						  <td>&nbsp;</td>
						  <td align="right" nowrap>&nbsp;</td>
						  <td>&nbsp;</td>
					  </tr>
					  
						<cfif dmodo EQ 'CAMBIO'>
							<tr><td colspan="4"><input type="hidden" name="LPlinea" value="<cfoutput>#rsFormDetalle.LPlinea#</cfoutput>"></td></tr>
						</cfif>
		
						<cfset dts = "">	
						<cfif dmodo neq "ALTA">
							<cfinvoke 
								component="sif.Componentes.DButils"
								method="toTimeStamp"
								returnvariable="dts">
								<cfinvokeargument name="arTimeStamp" value="#rsFormDetalle.ts_rversion#"/>
							</cfinvoke>
						</cfif>
						<tr><td><input type="hidden" name="dtimestamp" value="<cfif dmodo NEQ 'ALTA'><cfoutput>#dts#</cfoutput></cfif>"></td></tr>
					</table>
				</td>
			</tr>		
		</cfif>

		<!--- ============================================================================================================ --->
		<!---  											Botones													           --->
		<!--- ============================================================================================================ --->		
		<!-- Caso 1: Alta de Encabezados -->
		<cfif modo EQ 'ALTA'>
			<tr>
				<td align="center" valign="baseline">
					<input type="submit" name="btnAgregarE" value="Agregar" onClick="javascript: setBtn(this);" >
					<input type="reset"  name="btnLimpiar"  value="Limpiar" >
				</td>	
			</tr>
		</cfif>
		
		<!-- Caso 2: Cambio de Encabezados / Alta de detalles -->
		<cfif modo NEQ 'ALTA' and dmodo EQ 'ALTA' >
			<tr><td >&nbsp;</td></tr>						
			<tr>
				<td align="center" valign="baseline" >
					<input type="submit" name="btnAgregarD"  value="Agregar" onClick="javascript: setBtn(this);" >
					<input type="submit" name="btnBorrarE"   value="Borrar Lista de Precios" onClick="javascript: setBtn(this);" >
					<input type="reset"  name="btnLimpiar"   value="Limpiar" >
				</td>	
			</tr>
		</cfif>
		
		<!-- Caso 3: Cambio de Encabezados / Cambio de detalle -->		
		<cfif modo NEQ 'ALTA' and dmodo NEQ 'ALTA' >
			<tr><td >&nbsp;</td></tr>						
			<tr>
				<td align="center" valign="baseline" >
					<input type="submit" name="btnCambiarD" value="Cambiar" onClick="javascript: setBtn(this);" >
					<input type="submit" name="btnBorrarD"  value="Borrar L&iacute;nea" onClick="javascript: setBtn(this);" >
					<input type="submit" name="btnBorrarE"   value="Borrar Lista de Precios" onClick="javascript: setBtn(this);" >
					<input type="submit" name="btnNuevoD"   value="Nueva L&iacute;nea" onClick="javascript: setBtn(this);" >
					<input type="reset"  name="btnLimpiar"  value="Limpiar" >
					<cfif rsFormDetalle.LPtipo eq 'S'>
						<input type="submit" name="btnPaquetes" value="Paquetes"  onclick="javascript: paquetes();">
					</cfif>
				</td>	
			</tr>
		</cfif>

	</table>
	</cfoutput>
</form>

<script language="JavaScript1.2">	
	<cfoutput>
		<cfif modo neq 'ALTA' >
			//document.form1.Alm_Aid.alt  = "El Almacén"
			cambiar_tipo( document.form1.LPtipo.value, 'i' )

			<cfif dmodo neq 'ALTA' and rsFormDetalle.LPtipo eq 'A' >
				cambia_articulo( '<cfoutput>#rsFormDetalle.Aid#</cfoutput>', '<cfoutput>#rsFormDetalle.Alm_Aid#</cfoutput>' )
			</cfif>
			
		</cfif>
	</cfoutput>
</script>
