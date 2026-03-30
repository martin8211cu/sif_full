<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif modo NEQ "ALTA">
	<cfquery name="rsCtasConceptos" datasource="#Session.DSN#" >
	Select rtrim(ltrim(a.Ccodigo)) as Ccodigo, a.Dcodigo, a.Cid, a.timestamp, 
	convert(varchar,a.Ccuenta) as Ccuenta, b.Cdescripcion, b.Cformato,
	convert(varchar,a.Ccuentadesc) as Ccuentadesc, c.Cdescripcion as descCcuentadesc, c.Cformato as formatoCcuentadesc
    from CuentasConceptos a, CContables b, CContables c
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.Ccodigo = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ccodigo#" >))
		and a.Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#" >
		and a.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#" >
		and a.Ecodigo = b.Ecodigo 
		and a.Ccuenta = b.Ccuenta
		and a.Ccuentadesc = c.Ccuenta
	</cfquery>
</cfif>

<cfif modo EQ "ALTA">
	<cfquery name="rsCid" datasource="#Session.DSN#" >
	Select Cid , timestamp
    from Conceptos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Ccodigo = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ccodigo#" >))		  
	</cfquery>
</cfif>


<cfif isDefined("session.Ecodigo") and isDefined("Form.Cid") and len(trim(#Form.Cid#)) NEQ 0>
	<cfquery name="rsConceptos" datasource="#Session.DSN#" >
		Select Cid, Ecodigo, rtrim(ltrim(Ccodigo)) as Ccodigo, Ctipo, Cdescripcion, timestamp
        from Conceptos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#" >		  
		order by Cdescripcion asc
	</cfquery>
</cfif>

<cfif isDefined("session.Ecodigo") >
	<cfquery name="rsCContables" datasource="#Session.DSN#" >
	select Ccuenta,convert(varchar(25),Cdescripcion) Cdescripcion, Cformato 
    from CContables 
	where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
      and Cmovimiento='S' and Mcodigo = 1  
      order by Ccuenta
	</cfquery>
</cfif>

<cfif isDefined("session.Ecodigo") >
	<cfquery name="rsDeptos" datasource="#Session.DSN#">
		select * 
		from Departamentos 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
  		<cfif modo EQ "ALTA">
		and Dcodigo not in (	
			select Dcodigo 
			from CuentasConceptos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Ccodigo = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ccodigo#" >))
		)
		</cfif>
	</cfquery>
</cfif>

<script language="JavaScript" type="text/JavaScript">
function Conceptos(data) {
	document.form1.action='Conceptos.cfm';
	document.form1.submit();
}
</script>

<link href="sif.css" rel="stylesheet" type="text/css">
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
        if (p<1 || p==(val.length-1)) errors+='- '+nm+' no es una direccin de correo electrnica vlida.\n';
      } else if (test!='R') { num = parseFloat(val);
        if (isNaN(val)) errors+='- '+nm+' debe ser numrico.\n';
        if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
          min=test.substring(8,p); max=test.substring(p+1);
          if (num<min || max<num) errors+='- '+nm+' debe ser un nmero entre '+min+' y '+max+'.\n';
    } } } else if (test.charAt(0) == 'R') errors += '- '+nm+' es requerido.\n'; }
  } if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
  document.MM_returnValue = (errors == '');
}
//-->
</script>
<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
<form action="SQLCtaConcepto.cfm" method="post" name="form1" onSubmit="
			MM_validateForm('Dcodigo','','R','Ccuenta','','R','Ccuentadesc','','R');
			<cfif modo NEQ "ALTA">
				document.form1.Dcodigo.disabled=(!document.MM_returnValue);
			</cfif>
			return document.MM_returnValue">
  <table width="100%" cellpadding="0" cellspacing="0">
    <tr valign="baseline" bgcolor="#FFFFFF"> 
      <td align="right" nowrap>Concepto:</td>
      <td valign="middle">
          <input name="Ccodigo" type="text"  readonly="" value="<cfoutput>#Trim(Form.Ccodigo)#</cfoutput>" size="10" maxlength="10"  alt="El campo Descripcin del Concepto">
      </td>
    </tr>
    <tr valign="baseline"> 
      <td align="right" nowrap>Departamento:</td>
      <td align="left" nowrap><select name="Dcodigo"<cfif modo NEQ "ALTA">disabled</cfif>>
          <cfoutput query="rsDeptos"> 
            <option value="#rsDeptos.Dcodigo#" <cfif (isDefined("rsCtasConceptos.Dcodigo") AND rsDeptos.Dcodigo EQ rsCtasConceptos.Dcodigo)>selected</cfif>>#rsDeptos.Ddescripcion#</option>
          </cfoutput> </select></td>
    </tr>

    <tr valign="baseline"> 
      <td valign="middle" nowrap><div align="right">Cuenta:</div></td>
      <td valign="middle">
		<cfif modo NEQ "ALTA">
			<cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#rsCtasConceptos#" auxiliares="N" movimiento="S" form="form1"> 
		<cfelse>
			<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" form="form1"> 
		</cfif> 
	  </td>
    </tr>

	<tr valign="baseline"> 
      <td valign="middle" nowrap><div align="right">Cuenta de Descuentos:</div></td>
      <td valign="middle">
		<cfif modo NEQ "ALTA">
			<cfquery name="rsCC" dbtype="query">
				Select Ccuentadesc Ccuenta, descCcuentadesc Cdescripcion, formatoCcuentadesc Cformato
				from rsCtasConceptos
			</cfquery>	
			<cf_cuentas Conexion="#Session.DSN#" frame="frcuenta2" Conlis="S" query="#rsCC#" auxiliares="N" movimiento="S" ccuenta="Ccuentadesc" Cdescripcion="descCcuentadesc" cformato="formatoCcuentadesc">
		<cfelse>
			<cf_cuentas Conexion="#Session.DSN#" frame="frcuenta2" Conlis="S" auxiliares="N" movimiento="S" ccuenta="Ccuentadesc" Cdescripcion="descCcuentadesc" cformato="formatoCcuentadesc">
		</cfif>		  
	  </td>
    </tr>

    <tr valign="top"> 
      <td align="right" valign="middle" nowrap>&nbsp;</td>
    </tr>
    <tr valign="baseline"> 
      <td colspan="2" align="right" nowrap> <div align="center"> 
          <cfinclude template="../../portlets/pBotones.cfm">
          <cfif modo NEQ "ALTA">
          </cfif>
          <input name="Regresar" type="button" value="Conceptos" onClick="javascript:Conceptos('<cfoutput>#Trim(Form.Cid)#</cfoutput>')">
        </div></td>
    </tr>
  </table>
<cfset ts = "">
  <cfif modo NEQ "ALTA">
    <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsCtasConceptos.timestamp#"/>
	</cfinvoke>
</cfif>  
  <input type="hidden" name="timestamp" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32">
  <input type="hidden" name="Cid" value="<cfif modo EQ "ALTA"><cfoutput>#rsCid.Cid#</cfoutput> <cfelseif modo NEQ "ALTA"><cfoutput>#rsCtasConceptos.Cid#</cfoutput></cfif>">	
</form>


<!-- Texto para las validaciones -->
<script language="JavaScript1.1">
	document.form1.Dcodigo.alt = "El campo departamento" 
	document.form1.Ccuenta.alt = "El campo cuenta" 
	document.form1.Ccuentadesc.alt = "El campo cuenta de descuentos"
</script>
