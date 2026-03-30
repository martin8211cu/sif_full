<cfif isdefined("Url.id") and not isdefined("Form.id")>
	<cfparam name="Form.id" default="#Url.id#">
</cfif>
<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>
<cfif isdefined("Url.form") and not isdefined("Form.form")>
	<cfparam name="Form.form" default="#Url.form#">
</cfif>
<cfif isdefined("Url.Cconcepto") and not isdefined("Form.Cconcepto")>
	<cfparam name="Form.Cconcepto" default="#Url.Cconcepto#">
</cfif>
<cfif isdefined("Url.Eperiodo") and not isdefined("Form.Eperiodo")>
	<cfparam name="Form.Eperiodo" default="#Url.Eperiodo#">
</cfif>
<cfif isdefined("Url.Emes") and not isdefined("Form.Emes")>
	<cfparam name="Form.Emes" default="#Url.Emes#">
</cfif>
<cfif isdefined("Url.Edocumento") and not isdefined("Form.Edocumento")>
	<cfparam name="Form.Edocumento" default="#Url.Edocumento#">
</cfif>
<cfif isdefined("Url.Edescripcion") and not isdefined("Form.Edescripcion")>
	<cfparam name="Form.Edescripcion" default="#Url.Edescripcion#">
</cfif>
<cfif isdefined("Url.Efecha") and not isdefined("Form.Efecha")>
	<cfparam name="Form.Efecha" default="#Url.Efecha#">
</cfif>

<cfif isdefined("Url.intercompani") and not isdefined("Form.intercompani")>
	<cfset Form.intercompani=Url.intercompani>
<cfelse>
	<cfset Form.intercompani="0">
</cfif>

<cfinclude template="Funciones.cfm">
<cfset periodo="#get_val(30).Pvalor#">
<cfset mes="#get_val(40).Pvalor#">
<cfset mes="#mes-1#">
<cfif mes EQ 0>
	<cfset mes=12>
	<cfset periodo="#periodo-1#">
</cfif>

<cfquery name="rsConceptos" datasource="#Session.DSN#">
	select Cconcepto, Cdescripcion from ConceptoContableE 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsPeriodos" datasource="#Session.DSN#">
	select distinct Speriodo as Eperiodo
	from CGPeriodosProcesados
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Speriodo desc
</cfquery>

<!--- <cfset meses="Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre"> --->
<cfset meses="01,02,03,04,05,06,07,08,09,10,11,12">

<cfquery name="rsRegistros" datasource="#session.DSN#">
	select count(*) as cantidad
	from HEContables a
		<cfif isdefined("Form.intercompani") and (Form.intercompani EQ 1) and (Form.intercompani NEQ "all")>
            INNER JOIN EControlDocInt di on a.IDcontable=di.idcontableori
			INNER JOIN HDContablesInt hdi on hdi.IDcontable=di.idcontableori
        </cfif>
		inner join ConceptoContableE b
		 on b.Ecodigo   = a.Ecodigo 
		and b.Cconcepto = a.Cconcepto         
	where a.Ecodigo = #Session.Ecodigo#

	<cfif isdefined("Form.Cconcepto") and (Len(Trim(Form.Cconcepto)) NEQ 0) and (Form.Cconcepto NEQ "-1")>
		and a.Cconcepto = #Form.Cconcepto#
	</cfif>

 	<cfif isdefined("Form.Eperiodo") and (Len(Trim(Form.Eperiodo)) NEQ 0) and (Form.Eperiodo NEQ "-1")>
		and a.Eperiodo = #Form.Eperiodo#
	<cfelseif not isdefined("Form.Eperiodo")>
		and a.Eperiodo = #periodo#
	</cfif>

 	<cfif isdefined("Form.Emes") and (Len(Trim(Form.Emes)) NEQ 0) and (Form.Emes NEQ "-1")>
		and a.Emes = #Form.Emes#
	<cfelseif not isdefined("Form.Emes")>
		and a.Emes = #mes#
	</cfif>

 	<cfif isdefined("Form.Edocumento") and (Len(Trim(Form.Edocumento)) NEQ 0)>
		and a.Edocumento = #Form.Edocumento#
	</cfif>

	<cfif isdefined("Form.Edescripcion") and (Len(Trim(Form.Edescripcion)) NEQ 0)>
	  and upper(a.Edescripcion) like '%#Ucase(Form.Edescripcion)#%'
	</cfif>

	<cfif isdefined("Form.Efecha") and (Len(Trim(Form.Efecha)) NEQ 0)>
	  and a.Efecha >= #LSParseDateTime(Form.Efecha)#
	</cfif>    
    
	<cfif isdefined("Form.intercompani") and (Form.intercompani EQ 1) and (Form.intercompani NEQ "all")>
		and (a.ECtipo = 20 or a.ECtipo=21 )
	</cfif>
    
</cfquery>

<cfset LvarCantidadRegistros = rsRegistros.cantidad>
<cfif LvarCantidadRegistros GT 1000>
	<cfset LvarCantidadRegistros = 1000>
</cfif>

<cfquery name="conlis" datasource="#session.DSN#" maxrows="1000">
	select distinct
		a.IDcontable, 
		a.Edocumento, 
		a.Edescripcion, 
		a.Emes, 
		a.Eperiodo, 
		a.Efecha, 
		b.Cdescripcion,
        a.ECtipo,
        a.Cconcepto
	from HEContables a
        <cfif isdefined("Form.intercompani") and (Form.intercompani EQ 1) and (Form.intercompani NEQ "all")>
        	INNER JOIN EControlDocInt di on a.IDcontable=di.idcontableori
			INNER JOIN HDContablesInt hdi on hdi.IDcontable=di.idcontableori
        </cfif>
		inner join ConceptoContableE b
		 on b.Ecodigo = a.Ecodigo
		and b.Cconcepto = a.Cconcepto
	where a.Ecodigo = #Session.Ecodigo#
	<cfif isdefined("Form.Cconcepto") and (Len(Trim(Form.Cconcepto)) NEQ 0) and (Form.Cconcepto NEQ "-1")>
		and a.Cconcepto = #Form.Cconcepto#
	</cfif>
 	<cfif isdefined("Form.Eperiodo") and (Len(Trim(Form.Eperiodo)) NEQ 0) and (Form.Eperiodo NEQ "-1")>
		and a.Eperiodo = #Form.Eperiodo#
	<cfelseif not isdefined("Form.Eperiodo")>
		and a.Eperiodo = #periodo#
	</cfif>
 	<cfif isdefined("Form.Emes") and (Len(Trim(Form.Emes)) NEQ 0) and (Form.Emes NEQ "-1")>
		and a.Emes = #Form.Emes#
	<cfelseif not isdefined("Form.Emes")>
		and a.Emes = #mes#
	</cfif>
 	<cfif isdefined("Form.Edocumento") and (Len(Trim(Form.Edocumento)) NEQ 0)>
		and a.Edocumento = #Form.Edocumento#
	</cfif>
	<cfif isdefined("Form.Edescripcion") and (Len(Trim(Form.Edescripcion)) NEQ 0)>
	  and upper(a.Edescripcion) like '%#Ucase(Form.Edescripcion)#%'
	</cfif>
	<cfif isdefined("Form.Efecha") and (Len(Trim(Form.Efecha)) NEQ 0)>
	  and a.Efecha >= '#LSDateFormat(Form.Efecha,"yyyymmdd")#'
	</cfif>
    
    <cfif isdefined("Form.intercompani") and (Form.intercompani EQ 1) >
		and (a.ECtipo = 20 or a.ECtipo=21 )
	</cfif>
    
 	order by a.Eperiodo desc, a.Emes desc, a.Cconcepto, a.Edocumento 
</cfquery>

<script language="JavaScript" src="../../js/calendar.js"></script>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_validateForm() { //v4.0
  var i,p,q,nm,test,num,min,max,errors='',args=MM_validateForm.arguments;
  for (i=0; i<(args.length-2); i+=3) { test=args[i+2]; val=MM_findObj(args[i]);
    if (val) { if (val.alt!="") nm=val.alt; else nm=val.name; if ((val=val.value)!="") {
      if (test.indexOf('isEmail')!=-1) { p=val.indexOf('@');
        if (p<1 || p==(val.length-1)) errors+='- '+nm+' no es una dirección de correo electrónica válida.\n';
      } else if (test!='R') { num = parseFloat(val);
        if (isNaN(val)) errors+='- '+nm+' debe ser numérico.\n';
        if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
          min=test.substring(8,p); max=test.substring(p+1);
          if (num<min || max<num) errors+='- '+nm+' debe ser un número entre '+min+' y '+max+'.\n';
    } } } else if (test.charAt(0) == 'R') errors += '- '+nm+' es requerido.\n'; }
  } if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
  document.MM_returnValue = (errors == '');
}
//-->
</script>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_conlis" default="1">
<cfset MaxRows_conlis=22>
<cfset StartRow_conlis=Min((PageNum_conlis-1)*MaxRows_conlis+1,Max(LvarCantidadRegistros,1))>
<cfset EndRow_conlis=Min(StartRow_conlis+MaxRows_conlis-1,LvarCantidadRegistros)>
<cfset TotalPages_conlis=Ceiling(LvarCantidadRegistros/MaxRows_conlis)>
<cfset QueryString_conlis=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_conlis,"PageNum_conlis=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_conlis=ListDeleteAt(QueryString_conlis,tempPos,"&")>
</cfif>
<cfoutput>	
<cfif isdefined("Form.Cconcepto")>
	<cfset QueryString_conlis = "&id=#Form.id#&desc=#Form.desc#&form=#Form.form#&Cconcepto=#Form.Cconcepto#&Eperiodo=#Form.Eperiodo#&Emes=#Form.Emes#&Edocumento=#Form.Edocumento#&Efecha=#Form.Efecha#&Edescripcion=#URLEncodedFormat(Form.Edescripcion)#">
</cfif>
		
	<script language="JavaScript1.2">
		function Asignar(valor1, valor2) {
			window.opener.document.#Form.form#.#Form.id#.value = valor1;
			window.opener.document.#Form.form#.#Form.desc#.value = valor2;
			window.opener.document.#Form.form#.#Form.desc#.select();
			window.opener.document.#Form.form#.intercompany.value=document.getElementById("intercompani").value;
			window.close();
		}
		function Limpiar(f) {
			f.Cconcepto.selectedIndex = 0;
			for (var i=0; i<f.Eperiodo.length; i++) {
				if (f.Eperiodo[i].value == '#periodo#') {
					f.Eperiodo.selectedIndex = i;
					break;
				}
			}
			f.Emes.selectedIndex = #mes#;
			f.Edocumento.value = "";
			f.Edescripcion.value = "";
			f.Efecha.value = "";
		}
	</script>
</cfoutput>
<cfinvoke  key="LB_Titulo" default="Lista de Documentos Contables" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Titulo" xmlfile="ConlisPolizas.xml"/>
<cfinvoke  key="BTN_Filtrar" default="Filtrar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Filtrar" xmlfile="/sif/generales.xml"/>
<cfinvoke  key="BTN_Limpiar" default="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Limpiar" xmlfile="/sif/generales.xml"/>
<html>
<head>
<title><cfoutput>#LB_Titulo#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<cfflush interval="128">
	<body>
		<style type="text/css">
			.encabezado {
				font-weight: bold; 
				font-size: x-small; 
				background-color: #F5F5F5;
			}
			.encabReporte {
				background-color: #006699;
				font-weight: bold;
				color: #FFFFFF;
				padding-top: 10px;
				padding-bottom: 10px;
			}
		</style>
		<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
		<cfset PolizaE = t.Translate('PolizaE','P&oacute;liza')>
		<cfset PolizaVal = t.Translate('PolizaVal','El valor de la P&oacute;liza')>
			
		<form action="ConlisPolizas.cfm" name="conlis" onSubmit="MM_validateForm('Edocumento','','NisNum');return document.MM_returnValue">
		  
		  <table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr> 
			  <td class="encabezado"><cf_translate key=LB_Lote>Lote</cf_translate></td>
			  <td class="encabezado"><cf_translate key=LB_Poliza>P&oacute;liza</cf_translate></td>
			  <td class="encabezado"><cf_translate key=LB_Periodo>Per&iacute;odo</cf_translate></td>
			  <td class="encabezado"><cf_translate key=LB_Mes>Mes</cf_translate></td>
			  <td class="encabezado"><cf_translate key=LB_Descripcion>Descripci&oacute;n</cf_translate></td>
			  <td class="encabezado"><cf_translate key=LB_Fecha>Fecha </cf_translate></td>
              <td class="encabezado"><cf_translate key=LB_Tipo>Tipo</cf_translate></td>
			</tr>
			<tr> 
			  <td> 
				<select name="Cconcepto">
				  <option value="-1" <cfif isdefined("Form.Cconcepto") AND Form.Cconcepto EQ "-1">selected</cfif>>(<cf_translate key=LB_Todos>Todos</cf_translate>)</option>
				  <cfoutput query="rsConceptos"> 
					<option value="#rsConceptos.Cconcepto#" <cfif isdefined("Form.Cconcepto") AND rsConceptos.Cconcepto EQ Form.Cconcepto>selected</cfif>>#rsConceptos.Cdescripcion#</option>
				  </cfoutput> 
				</select>
			  </td>
			  <td>
			  	<cfoutput>
					<input name="Edocumento" type="text" id="Edocumento" size="10" maxlength="15" alt="#PolizaVal#" value="<cfif isdefined("Form.Edocumento")>#Form.Edocumento#</cfif>">
				</cfoutput>
			  </td>
			  <td> 
				<select name="Eperiodo">
				  <option value="-1">(Todos)</option>
				  <cfoutput query="rsPeriodos"> 
					<option value="#rsPeriodos.Eperiodo#" <cfif isdefined("Form.Eperiodo") AND rsPeriodos.Eperiodo EQ Form.Eperiodo>selected<cfelseif not isdefined("Form.Eperiodo") AND periodo EQ rsPeriodos.Eperiodo>selected</cfif>>#rsPeriodos.Eperiodo#</option>
				  </cfoutput> 
				</select>
			  </td>
			  <cfoutput>
			  <td> 
				<select name="Emes" size="1">
					  <option value="-1" <cfif isdefined("Form.Emes") AND Form.Emes EQ "-1">selected</cfif>>(<cf_translate key=LB_Todos>Todos</cf_translate>)</option>
					  <cfloop index="i" from="1" to="#ListLen(meses)#">
						<option value="#i#" <cfif isdefined("Form.Emes") AND Form.Emes EQ i>selected<cfelseif not isdefined("Form.Emes") AND mes EQ i>selected</cfif>> 
						#ListGetAt(meses,i)# </option>
					  </cfloop>

				</select>
			  </td>
			  <td> 
				<input name="Edescripcion" type="text" id="Edescripcion" size="20" maxlength="100" value="<cfif isdefined("Form.Edescripcion")>#Form.Edescripcion#</cfif>">
			  </td>
			  <td nowrap> 
				<cfset vFecha = ''>
				<cfif isdefined("form.Efecha") and len(trim(form.Efecha))>
					<cfset vFecha = form.Efecha>
				</cfif>
				<cf_sifcalendario name="Efecha" value="#vFecha#" form="conlis">
			  </td>
              <td align="center">
              	<select name="intercompani" id="intercompani" >
                	<!---<option value="all" <cfif isdefined("Form.intercompani") AND Form.intercompani EQ "all">selected</cfif>>Todos</option>--->
                    <option value="0" <cfif isdefined("Form.intercompani") AND Form.intercompani EQ "0">selected</cfif>>Normal</option>
                	<option value="1" <cfif isdefined("Form.intercompani") AND Form.intercompani EQ "1">selected</cfif>><cf_translate  key=LB_Intercopania>Intercompa&ntilde;ia</cf_translate></option>
                </select>
              </td>
			</tr>
			<tr align="center"> 
			  <td colspan="7">
				<input name="id" type="hidden" id="id" value="<cfif isdefined("Form.id")>#Form.id#</cfif>">
				<input name="desc" type="hidden" id="desc" value="<cfif isdefined("Form.desc")>#Form.desc#</cfif>">
				<input name="form" type="hidden" id="form" value="<cfif isdefined("Form.form")>#Form.form#</cfif>">
				<input name="btnFiltrar" type="submit" id="btnFiltrar2" value="#BTN_Filtrar#">
				<input name="btnLimpiar" type="button" id="btnLimpiar" value="#BTN_Limpiar#" onClick="javascript:Limpiar(this.form);">
			  </td>
			</tr>
			</cfoutput>
			<tr> 
			  <td colspan="7">
				<cfif LvarCantidadRegistros GT 0>
					<table cellpadding="0" cellspacing="0" border="0" width="100%">
					  <tr> 
						<td class="encabReporte"><cf_translate key=LB_Lote>Lote</cf_translate></td>
						<td class="encabReporte" align="center"><cf_translate key=LB_Poliza>P&oacute;liza</cf_translate></td>
						<td class="encabReporte"><cf_translate key=LB_Descripcion>Descripci&oacute;n</cf_translate></td>
						<td class="encabReporte" align="center"><cf_translate key=LB_Mes>Mes</cf_translate></td>
						<td class="encabReporte" align="center"><cf_translate key=LB_Periodo>Per&iacute;odo</cf_translate></td>
						<td class="encabReporte" align="center"><cf_translate key=LB_Fecha>Fecha</cf_translate></td>
                        <td class="encabReporte" align="center"><cf_translate key=LB_Tipo>Tipo</cf_translate></td>
					  </tr>
					  <cfset vCurrentrow = 0 >
					  <cfoutput>
						  <cfloop query="conlis" startrow="#StartRow_conlis#" endrow="#StartRow_conlis + MaxRows_conlis - 1#">
							  <cfset vCurrentrow = vCurrentrow + 1 >
							<tr> 
							  <input type="hidden" name="IDcontable#vCurrentrow#" value="#IDcontable#">
							  <td nowrap <cfif #vCurrentrow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>> 
								<a href="javascript:Asignar('#IDcontable#','#JSStringFormat(Edescripcion)#');">#Cdescripcion#</a></td>
							  <td align="center" nowrap <cfif #vCurrentrow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>> 
								<a href="javascript:Asignar('#IDcontable#','#JSStringFormat(Edescripcion)#');">#Edocumento#</a></td>
							  <td nowrap <cfif #vCurrentrow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>> 
								  <cfset punto="">
								  <cfif Len(Trim(#Edescripcion#)) GT 60><cfset punto = " ..."></cfif>
								<a href="javascript:Asignar('#IDcontable#','#JSStringFormat(Edescripcion)#');">#Mid(Edescripcion,1,60)##punto#</a></td>
							  <td align="center" <cfif #vCurrentrow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>> 
								<a href="javascript:Asignar('#IDcontable#','#JSStringFormat(Edescripcion)#');">#ListGetAt(meses, Emes, ',')#</a></td>
							  <td align="center" <cfif #vCurrentrow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>> 
								<a href="javascript:Asignar('#IDcontable#','#JSStringFormat(Edescripcion)#');">#Eperiodo#</a></td>
							  <td align="center" <cfif #vCurrentrow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>> 
								<a href="javascript:Asignar('#IDcontable#','#JSStringFormat(Edescripcion)#');">#LSDateFormat(Efecha,'dd/mm/yyyy')#</a></td>
                              <td align="left" <cfif #vCurrentrow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>> 
								<a href="javascript:Asignar('#IDcontable#','#JSStringFormat(Edescripcion)#');"><cfif ECtipo EQ 20 OR ECtipo EQ 21>Intercompa&ntilde;&iacute;a<cfelse>Normal</cfif></a></td>
							</tr>
						  
						  </cfloop>
					  </cfoutput> 
					</table>
					<br>
					<table border="0" width="50%" align="center">
					   <cfoutput>
						<tr> 
						  <td width="23%" align="center"> 
							<cfif PageNum_conlis GT 1>
							  <a href="#CurrentPage#?PageNum_conlis=1#QueryString_conlis#&intercompani=#form.intercompani#"><img src="../../imagenes/First.gif" border=0></a> 
							</cfif>
						  </td>
						  <td width="31%" align="center"> 
							<cfif PageNum_conlis GT 1>
							  <a href="#CurrentPage#?PageNum_conlis=#Max(DecrementValue(PageNum_conlis),1)# #QueryString_conlis#&intercompani=#form.intercompani#"><img src="../../imagenes/Previous.gif" border=0></a> 
							</cfif>
						  </td>
						  <td width="23%" align="center"> 
							<cfif PageNum_conlis LT TotalPages_conlis>
							  <a href="#CurrentPage#?PageNum_conlis=#Min(IncrementValue(PageNum_conlis),TotalPages_conlis)##QueryString_conlis#&intercompani=#form.intercompani#"><img src="../../imagenes/Next.gif" border=0></a> 
							</cfif>
						  </td>
						  <td width="23%" align="center"> 
							<cfif PageNum_conlis LT TotalPages_conlis>
							  <a href="#CurrentPage#?PageNum_conlis=#TotalPages_conlis##QueryString_conlis#&intercompani=#form.intercompani#"><img src="../../imagenes/Last.gif" border=0></a> 
							</cfif>
						  </td>
						</tr>
					  </cfoutput>
					</table>
				<cfelse>
					<br/>
						<p align="center">NO SE ENCONTRARON REGISTROS QUE CUMPLAN CON EL CRITERIO DE B&Uacute;SQUEDA</p>
					<br/>
					<div align="center"><input type="button" name="btnCerrar" value="Cerrar Ventana" onClick="javascript:window.close();"></div>
				</cfif>
				<div align="center"> </div>
			  </td>
			</tr>
		  </table>
		</form> 
	</body>
</html>