<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 11-5-2006.
		Motivo: Se corrige el join del usuario por que usaba el BMUsucodigoAnul y el correcto es el BMUsucodigo 
			para que se pinte el usuario.
			Se guarda el SNcodigo y el tab en el form para que al hacer cambio mantenga el socio y el tab que
			esta utilizando el usuario.
			Se valida que no se pueda dar enter en el textbox sin que se asigne la variable FALiberaCreditoID, 
			para que no de error en el SQL.
 --->
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfif isDefined("url.MaxRows") and len(Trim(url.MaxRows)) gt 0>
	<cfset form.MaxRows = url.MaxRows>
</cfif>
<cfif isDefined("url.tab") and len(Trim(url.tab)) gt 0>
	<cfset form.tab = url.tab>
</cfif>
<cfparam name="Form.MaxRows" default="15">

<cfif isdefined('form.MaxRows') and form.MaxRows EQ ''>
	<cfset Form.MaxRows = 15>
</cfif>
<form action="LibTranPV-sql.cfm" method="post" name="form1" onsubmit="return Validar();">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
	<input type="hidden" name="FALiberaCreditoID" value="">
	<cfoutput>
		<input name="SNcodigo" type="hidden" value="#form.SNcodigo#">
	</cfoutput>
	
	<cfquery name="rsFALiberaCre" datasource="#session.dsn#">
		select	a.FALiberaCreditoID, 
	  			a.FAM01COD, 
				a.FAX01NTR, 
				a.FAX01NTE, 
				b.Miso4217 as Mcodigo, 
				a.MontoMax, 
				3 as tab,
	  			a.FechaFactura, 
				a.MontoUtilizado, 
				'<img style=''cursor:hand;'' alt=''Eliminar'' border=''0'' src=''../../imagenes/Borrar01_S.gif'' onClick=''javascript: eliminar('#_Cat#<cf_dbfunction name="to_char" args="a.FALiberaCreditoID">#_Cat#');''>' as imagen,
	  			c.FAM01CODD,
				(select Usulogin 
					from Usuario 
					where Usucodigo = a.BMUsucodigo
				) as usuario

		from  FALiberaCredito a
 		inner join  Monedas b
			on a.Ecodigo = b. Ecodigo 
		  	and a.Mcodigo = b.Mcodigo

		left outer join FAM001 c
			on a.Ecodigo = c.Ecodigo
			and a.FAM01COD = c.FAM01COD

		where <!--- coalesce(MotivoAnula,'null')='null' --->
		  LibAnulada = 0
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">

	</cfquery>
	<cfif isdefined('form.tab') and len(trim(form.tab))>
		<cfset varTab = "&tab=" & form.tab>
	</cfif>
	<cfset navegacion = "SNcodigo=#form.SNcodigo#&maxrows=#form.maxrows#" & varTab>
   <cfinvoke 
     component="sif.Componentes.pListas"
     method="pListaQuery"
     returnvariable="pListaPVRet">
     <cfinvokeargument name="query" value="#rsFALiberaCre#"/>
     <cfinvokeargument name="desplegar" value="FAM01CODD, FAX01NTR,FAX01NTE,Mcodigo, MontoMax,FechaFactura,MontoUtilizado, usuario, imagen"/>
     <cfinvokeargument name="etiquetas" value="Caja,No Transacción,No Trans Externa,Moneda, Monto Autorizado,Fecha Factura,Monto Utilizado, Usuario, Anular"/>
     <cfinvokeargument name="formatos" value="S, I, S, S, M, D,M,S,S"/>
     <cfinvokeargument name="align" value="left,center,center,center,right,center,right,center, right"/>
     <cfinvokeargument name="ajustar" value="N"/>
     <cfinvokeargument name="MaxRows" value="10"/>
     <cfinvokeargument name="incluyeform" value="false">
	 <cfinvokeargument name="formname" value="form1"/>
	 <cfinvokeargument name="irA" value="LibTranPV-sql.cfm"/>
	  <cfinvokeargument name="showLink" value="false">
     <cfinvokeargument name="showEmptyListMsg" value="true">
     <cfinvokeargument name="EmptyListMsg" value="*** NO SE HA REGISTRADO NINGUNA TRANSACCION ***">
     <cfinvokeargument name="navegacion" value="#navegacion#">
    </cfinvoke>

	</td>
	
	
  </tr>
  <tr>
  	<td>&nbsp;</td>
  </tr>
  

	<tr>
		<td>
			<center> Motivo de Anulaci&oacute;n: <input name="MotivoAnulacion" type="text" maxlength="255" size="100" ></center>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>
</form>
<cf_qforms form="form1" objForm="objForm">

<script language="javascript" type="text/javascript">
	function Validar(){
		if ( document.form1.FALiberaCreditoID.value == ''){
			alert('Debe escoger una línea para eliminarla');
			return false;
		}
		else
			return true;
	}
		
	function validaAnula(){
		if ( document.form1.MotivoAnulacion.value == ''){
			alert('El Motivo de la Anulación no puede estar vacio');
			document.form1.MotivoAnulacion.value = '';
			return false;
		}
	}
	function eliminar(valor){
		
		if ( document.form1.MotivoAnulacion.value == ''){
			alert('El Motivo de la Anulación no puede estar vacio');
			document.form1.MotivoAnulacion.value = '';
			return false;
		}
		else
		{
			if ( confirm('Desea eliminar el registro?') ) {
				document.form1.FALiberaCreditoID.value = valor;
				document.form1.submit();
			}	
		}
	}
	
</script>