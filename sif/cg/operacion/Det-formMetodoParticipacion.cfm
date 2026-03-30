<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Porcentaje" default="Porcentaje de Participación"
returnvariable="LB_Porcentaje" xmlfile="Det-formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Capital" default="Capital" returnvariable="LB_Capital"
xmlfile="Det-formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_tipoCambio" default="Tipo de Cambio" returnvariable="LB_tipoCambio" xmlfile="Det-formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CuentaC" default="Cuenta Débitos" returnvariable="LB_CuentaC"
xmlfile="Det-formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CuentaD" default="Cuenta Créditos" returnvariable="LB_CuentaD"
xmlfile="Det-formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Monto" default="Monto" returnvariable="LB_Monto"
xmlfile="Det-formMetodoParticipacion.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_DeseaEliminarEsteDetalle" default="¿Desea eliminar esta l&iacute;nea de detalle?" returnvariable="MSG_DeseaEliminarEsteDetalle" xmlfile="Det-formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_ElCampoNoPuedeSerMayorACienNiMenorQueCero" default="El campo no puede ser mayor a 100 ni menor que cero" returnvariable="MSG_ElCampoNoPuedeSerMayorACienNiMenorQueCero" xmlfile="Det-formMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_NoPuedeHaberPorcentajeCapitalCero" default="No puede haber Porcentaje, o Capital en 0" returnvariable="MSG_NoPuedeHaberPorcentajeCapitalCero"
xmlfile="Det-formMetodoParticipacion.xml">


<cfset modoDet = 'ALTA'>
<cfquery name="VerificaDetalle" datasource="#Session.DSN#">
            select * from DMetPar
            where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
            and  MetParID = <cfqueryparam value="#Form.MetParID#" cfsqltype="cf_sql_numeric">
 </cfquery>



<cfif  isdefined('form.MetParID') and len(trim(form.MetParID)) and VerificaDetalle.recordcount gt 0>
	<cfset modoDet = 'CAMBIO'>
</cfif>
<cfquery name="rsPeriodo" datasource="#Session.DSN#">
	select Pvalor as Periodo
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and Pcodigo = 50
</cfquery>
<cfquery name="rsMes" datasource="#Session.DSN#">
	select Pvalor as Mes
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and Pcodigo = 60
</cfquery>

<cfquery name="rsMonedas" datasource="#Session.DSN#">
	Select Mcodigo,Mnombre,Miso4217
	from Monedas m
	where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
    order by Mnombre
</cfquery>

<cfquery name="rsMonedaLocal" datasource="#session.DSN#">
	select Mcodigo from Empresas
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>


<cfquery name="rsFormDet3" datasource="#session.DSN#">
		Select  dmp.MetParID, emp.SNid,dmp.Fecha,dmp.Periodo,dmp.Mes, dmp.CCuentaCR as CCuenta,pctjePart, Capital, Monto, emp.ts_rversion, ArchSoporte,NomArchSop
		from EMetPar emp
        	inner join DMetPar dmp
            on emp.Ecodigo = dmp.Ecodigo and emp.MetParID = dmp.MetParID
		where emp.MetParID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MetParID#">
</cfquery>

<cfif modoDet NEQ 'ALTA'>


    <cfquery name="rsFormDet" datasource="#session.DSN#">
		Select  dmp.MetParID, emp.SNid,dmp.Fecha,dmp.Periodo,dmp.Mes, dmp.CCuentaCR as CCuenta,pctjePart, Capital, Monto, emp.ts_rversion, ArchSoporte, NomArchSop
		from EMetPar emp
        	inner join DMetPar dmp
            on emp.Ecodigo = dmp.Ecodigo and emp.MetParID = dmp.MetParID
		where emp.MetParID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MetParID#">
	</cfquery>

	<cfquery name="rsForm5" datasource="#session.DSN#">
 		Select * from EMetPar emp
        left join DMetPar dmp on emp.MetParID=dmp.MetParID and emp.Ecodigo=dmp.Ecodigo
		where emp.Ecodigo= <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and emp.MetParID=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MetParID#">
	</cfquery>



    <cfquery name="rsFormDet2" datasource="#session.DSN#">
		Select  dmp.MetParID, emp.SNid,dmp.Fecha,dmp.Periodo,dmp.Mes, dmp.CCuentaDB as CCuenta
		from EMetPar emp
        	inner join DMetPar dmp
            on emp.Ecodigo = dmp.Ecodigo and emp.MetParID = dmp.MetParID
		where emp.MetParID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MetParID#">
	</cfquery>
</cfif>


<cfquery name="TCsugAux" datasource="#Session.DSN#">
	select tc.Mcodigo, tc.TCcompra, tc.TCventa
	from Htipocambio tc
	where tc.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	  and tc.Hfecha <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha#">
	  and tc.Hfechah >  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha#">
</cfquery>


<!---<cf_dump var="#rsForm#">--->
<cfoutput>
<form name="formDetMetPar" method="post" action="SQLMetodoParticipacion.cfm" enctype="multipart/form-data" onSubmit=" xa='';

if(formDetMetPar.Monto.value == 0){
xa = xa + '\n -El Monto no puede estar en 0';

}

if(formDetMetPar.Ccuenta1.value == null || formDetMetPar.Ccuenta1.value == '' || formDetMetPar.Ccuenta1.value== '0'){
xa = xa + '\n -Se debe indicar la Cuenta de D&eacute;bitos';

}

if(formDetMetPar.Ccuenta2.value == null || formDetMetPar.Ccuenta2.value == '' ||formDetMetPar.Ccuenta2.value == '0'){
xa = xa + '\n -Se debe indicar la Cuenta de Cr&eacute;ditos';

}


if(xa.length>0){
  alert('Se presentaron los siguientes errores: \n' + xa);
  return false;
}else{

return true;
}">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr><td>&nbsp;</td></tr>
      <tr>
        <td align="right"><strong>#LB_Porcentaje#:</strong></td>
         <td><input name="porcentajePar" type="text" id="porcentajePar" <cfif modoDet NEQ 'Alta'> value="#LSNumberFormat(rsFormDet.pctjePart,',9.0000')#"<cfelse> value="0.0000"</cfif> style="text-align: right" size="20" maxlength="18" tabindex="26" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,4);" onChange="calcTotal();" onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {calcTotal();}"></td>

        <td align="right"><strong>#LB_Capital#:</strong></td>
         <td><input name="Capital" type="text" id="Capital" <cfif modoDet NEQ 'Alta'> value="#LSNumberFormat(rsFormDet.Capital,',9.0000')#"<cfelse> value="0.0000"</cfif> style="text-align: right" size="20" maxlength="18" tabindex="26" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,4);" onChange="calcTotal();" onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}"></td>

		<td align="right"><strong>#LB_Moneda#:</strong></td>
        <td>
            	<select <cfif isdefined('VerificaDetalle') and VerificaDetalle.recordCount GT 0> disabled</cfif> name="Mcodigo" tabindex="7" onChange="cambioMoneda(this);">
					<cfif isdefined('rsMonedas') and rsMonedas.recordCount GT 0>
						<cfloop query="rsMonedas">
							<cfif modoDet NEQ 'ALTA'>
								<option value="#Mcodigo#" <cfif rsMonedas.Mcodigo eq rsForm5.Mcodigo>selected </cfif>>(#Miso4217#)&nbsp;#Mnombre#</option>
							<cfelse>
								<option value="#Mcodigo#" <cfif rsMonedas.Mcodigo EQ rsMonedaLocal.Mcodigo> selected</cfif>>(#Miso4217#)&nbsp;#Mnombre#</option>
							</cfif>

						</cfloop>
					</cfif>
				</select>
			</td>

     <td align="right"><strong>#LB_tipoCambio#:</strong></td>
        <td><input name="TipoCambio" type="text" readonly id="TipoCambio" <cfif modoDet NEQ "ALTA"> value="#LSNumberFormat(rsForm5.TC,',9.00')#" <cfelse> value = "#LSNumberFormat(1,',9.00')#" </cfif> style="text-align: right"  size="20" maxlength="18" tabindex="8" onFocus="this.value=qf(this); this.select();" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
            </td>
     </tr>
           <tr><td>&nbsp;</td></tr>
     <tr>
		<td align="right"><strong>#LB_CuentaC#:</strong></td>
        <td colspan="3">
				<cfif modo NEQ "ALTA" AND isdefined('rsFormDet') AND rsFormDet.CCuenta NEQ ''>
                	<cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#rsFormDet#" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="Ccuenta1" cdescripcion="CdescripcionD1"  cmayor="CmayorD1" cformato="CformatoD1" form="formDetMetPar"
					tabindex="22">
				<cfelse>
                    <cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="Ccuenta1" cdescripcion="CdescripcionD1"  cmayor="CmayorD1" cformato="CformatoD1" form="formDetMetPar"
					tabindex="22">
				</cfif>
		</td>
        <td align="right"><strong>#LB_Monto#:</strong></td>
        <td>
        <input name="Monto" type="text" readonly id="Monto" <cfif modoDet NEQ "ALTA"> value="#LSNumberFormat(rsFormDet.Monto,',9.0000')#" <cfelse> value = "#LSNumberFormat(0,',9.0000')#" </cfif> style="text-align: right"  size="20" maxlength="18" tabindex="8" onBlur="fm(this,4);">
            </td>
      </tr>
      <tr><td>&nbsp;</td></tr>
      <tr>
		<td align="right"><strong>#LB_CuentaD#:</strong></td>
        <td colspan="3">
				<cfif modo NEQ "ALTA" AND isdefined('rsFormDet') AND rsFormDet2.CCuenta NEQ ''>
                	<cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#rsFormDet2#" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="Ccuenta2" cdescripcion="CdescripcionD2"  cmayor="CmayorD2" cformato="CformatoD2" form="formDetMetPar"
					tabindex="23">
				<cfelse>
                    <cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" descwidth="20"
					ccuenta="Ccuenta2" cdescripcion="CdescripcionD2"  cmayor="CmayorD2" cformato="CformatoD2" form="formDetMetPar"
					tabindex="23">
				</cfif>
		</td>
        <td align="right"><strong>#LB_Monto#:</strong></td>
        <td><input name="Monto2" type="text" readonly id="Monto2" <cfif modoDet NEQ "ALTA"> value="#LSNumberFormat(rsFormDet.Monto,',9.0000')#" <cfelse> value = "#LSNumberFormat(0,',9.0000')#" </cfif> style="text-align: right"  size="20" maxlength="18" tabindex="8" onBlur="fm(this,4);">
            </td>
      </tr>
      <tr>
      <td>&nbsp;</td></tr>
      <tr>
            <input type="hidden" name="AFnombreImagen" value="">
			<input type="hidden" name="AFnombre" value="">

    <cfif rsFormDet3.NomArchSop neq ''>
       <td align="right"><strong>Archivo:</strong></td>
	   <td align="center">#rsFormDet3.NomArchSop#</td>
	   <tr>
      <td>&nbsp;</td></tr>
      <tr>

  <cfelse>
      <table>
      <td><strong>Archivo/Imagen:</strong>&nbsp;</td>
			<td><input type="file" name="AFimagen" value="" onChange="javascript:extraeNombre(this.value);" size="40" tabindex="100"></td>

	  </table>

	</cfif>

	   <td>&nbsp;</td>

	</tr>

      <tr>

        <td colspan="6" align="center">
			<input type="hidden" name="MetParID" value="#form.MetParID#">

			<input type="hidden" name="ts_rversion" value="#ts#">

			<cfif modoDet neq 'ALTA' >
				<cfset tsDet = "">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
					artimestamp="#rsFormDet.ts_rversion#" returnvariable="tsDet">
				</cfinvoke>
				<input type="hidden" name="ts_rversionDet" value="#tsDet#">
			<cfif rsFormDet3.NomArchSop neq ''>
				<cf_botones tabindex="29" modo='CAMBIO' sufijo="Det" exclude="nuevo" include="Eliminar_Archivo">
			<cfelse>
			     <cf_botones tabindex="29" modo='CAMBIO' sufijo="Det" exclude="nuevo">
			</cfif>
			<cfelse>
			<cf_botones tabindex="29" modo='ALTA' sufijo="Det">


            </cfif>




		</td>
      </tr>
    </table>
</form>
<iframe name="frSP" id="frSP" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: ;"></iframe>
</cfoutput>

<cf_qforms form="formDetMetPar" objForm="objFormDet">

<script language="javascript" type="text/javascript">

function cambioMoneda(cb){
			if (cb.value == <cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>){
				document.formDetMetPar.TipoCambio.value = "1.00";
				calcTotal();
			}else{

				<cfwddx action="cfml2js" input="#TCsugAux#" topLevelVariable="rsTCsug">
				//Verificar si existe en el recordset
				 var nRows = rsTCsug.getRowCount();
				<!--- var nRows2 = rsTCsugAux.getRowCount(); --->
				if (nRows > 0) {
					for (row = 0; row < nRows; ++row) {
						if (rsTCsug.getField(row, "Mcodigo") == cb.value) {
							document.formDetMetPar.TipoCambio.value = rsTCsug.getField(row, "<cfoutput>#TC#</cfoutput>");
									calcTotal();
							row = nRows;
						}else{
							document.formDetMetPar.TipoCambio.value = "0.00";
							calcTotal();
						}


					}
				}else{
					document.formDetMetPar.TipoCambio.value = "0.00";
					calcTotal();
				}
			}
		}

function calcula (){
	document.formDetMetPar.Monto.value="44";

}


	function calcTotal(){
	validaPorcentaje();

		if(document.formDetMetPar.porcentajePar.value == "") document.formDetMetPar.porcentajePar.value = "0.00"
		if(document.formDetMetPar.Capital.value == "") document.formDetMetPar.Capital.value = "0.00"
		if(document.formDetMetPar.Monto.value == "") document.formDetMetPar.Monto.value = "0.00"
		if(document.formDetMetPar.Monto2.value == "") document.formDetMetPar.Monto2.value = "0.00"


		var porcentajePar = new Number(qf(document.formDetMetPar.porcentajePar.value))
		var Capital = new Number(qf(document.formDetMetPar.Capital.value))
		var Monto = new Number(qf(document.formDetMetPar.Monto.value))
		var Monto2 = new Number(qf(document.formDetMetPar.Monto2.value))
		var TCambio = new Number(qf(document.formDetMetPar.TipoCambio.value))
		var seguir = "si"

		valor = (Capital * TCambio) * (porcentajePar/100) ;

		document.formDetMetPar.Monto.value = ((Capital * TCambio) * (porcentajePar/100)).toFixed(4) ;
		fm(document.formDetMetPar.Monto,4);
		document.formDetMetPar.Monto2.value =((Capital * TCambio) * (porcentajePar/100)).toFixed(4) ;
		fm(document.formDetMetPar.Monto2,4);

		if(porcentajePar < 0){
			document.formDetMetPar.porcentajePar.value="0.00"
			seguir = "no"
		}

		if(Capital < 0){
			document.formDetMetPar.Capital.value="0.00"
			seguir = "no"
		}

		if(Monto < 0){
			document.formDetMetPar.Monto.value="0.00"
			seguir = "no"
		}
		if(Monto2 < 0){
			document.formDetMetPar.Monto2.value="0.00"
			seguir = "no"
		}

		validaPorcentaje();

	}


function validaPorcentaje(){

if((document.formDetMetPar.porcentajePar.value)>100 || (document.formDetMetPar.porcentajePar.value)<0){
   alert('El Campo no puede ser Mayor a 100, ni menor a 0');
   document.formDetMetPar.porcentajePar.value='';
 }
}



	function extraeNombre(value){
	 var extensionTemp = "";
	  var nombreArchivo = "";

	 for(i=value.length-1;i>=0;i--)
	  {
		  if(value.charAt(i) == '.')
			{
			   break;
			}
		    else
		    {
		     extensionTemp = value.charAt(i)+extensionTemp ;
		    }
	   }

		document.formDetMetPar.AFnombreImagen.value=extensionTemp;

	 for(i=value.length-1;i>=0;i--)
	  {
		  if(value.charAt(i) == '\\')
			{
			   break;
			}
		    else
		    {
		     nombreArchivo = value.charAt(i)+nombreArchivo ;
		    }
	   }

		document.formDetMetPar.AFnombre.value=nombreArchivo;


	}



</script>
