<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate" xmlfile="formMapeoCuentasCE.xml"/>
<cfinvoke key="LB_Clasificacion" default="Clasificaci&oacute;n" returnvariable="LB_Clasificacion" component="sif.Componentes.Translate" method="Translate" xmlfile="formMapeoCuentasCE.xml"/>
<cfinvoke key="LB_TitleCuentas" default="Cuentas" returnvariable="LB_TitleCuentas" component="sif.Componentes.Translate" method="Translate" xmlfile="formMapeoCuentasCE.xml"/>
<cfinvoke key="LB_TitleMas" default="Agregar la cuenta seleccionada." returnvariable="LB_TitleMas" component="sif.Componentes.Translate" method="Translate" xmlfile="formMapeoCuentasCE.xml"/>
<cfinvoke key="LB_TitleMenos" default="Agrega la cuenta seleccionada y las subcuentas asociadas a esta." returnvariable="LB_TitleMenos" component="sif.Componentes.Translate" method="Translate" xmlfile="formMapeoCuentasCE.xml"/>
<cfinvoke key="LB_TitleCuenta" default="Permite eliminar solo esta cuenta." returnvariable="LB_TitleCuenta" component="sif.Componentes.Translate" method="Translate" xmlfile="formMapeoCuentasCE.xml"/>
<cfinvoke key="LB_TitleSubcuenta" default="Permite eliminar la cuenta y subcuentas asociadas a esta." returnvariable="LB_TitleSubcuenta" component="sif.Componentes.Translate" method="Translate" xmlfile="formMapeoCuentasCE.xml"/>
<cfinvoke key="CMB_Eliminar" default="Eliminar" returnvariable="CMB_Eliminar" component="sif.Componentes.Translate" method="Translate" xmlfile="formMapeoCuentasCE.xml"/>
<cfinvoke key="CMB_Regresar" default="Regresar" returnvariable="CMB_Regresar" component="sif.Componentes.Translate" method="Translate" xmlfile="formMapeoCuentasCE.xml"/>


<cfquery name="nivel" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200080 AND Mcodigo = 'CE'
</cfquery>
<cfquery name="valOrden" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200081 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<cfif not isdefined("modom")>
    <cfset modom="ALTA">
</cfif>

<cfset array_cuenta = ArrayNew(1)>

<cfif modom neq 'ALTA'>
	<cfquery datasource="#Session.DSN#" name="rs">
		SELECT cec.CCuentaSAT, cec.NombreCuenta,
		cta.Cmayor, cta.Cdescripcion AS CdescripcionMayor,
		cco.Cformato, cco.Cdescripcion
		FROM  CECuentasSAT cec
		INNER JOIN CEMapeoSAT cem ON cec.CCuentaSAT=cem.CCuentaSAT
		AND cec.CAgrupador=cem.CAgrupador AND cem.Ccuenta='#form.Ccuenta#' AND cem.CAgrupador='#trim(form.CAgrupador)#'
		INNER JOIN CContables cco ON cem.Ccuenta=cco.Ccuenta
		INNER JOIN CtasMayor  cta ON cta.Cmayor=cco.Cmayor
	</cfquery>
	<cfif #rs.RecordCount# neq 0>

		<cfset ArrayAppend(array_cuenta, "#rs.Cformato#")>
		<cfset ArrayAppend(array_cuenta, "#rs.Cdescripcion#")>

	</cfif>

</cfif>

<cfset LvarAction   = 'SQLMapeoCuentasCE.cfm'>

<cfset LvarFiltro = '' >

<cfif #nivel.Pvalor# neq '-1'>
	<cfset LvarFiltro = 'and b.PCDCniv <= (	select isnull(Pvalor,2) Pvalor from Parametros where Ecodigo = #session.Ecodigo# and Pcodigo = 200080) -1'>
<cfelse>
<cfset LvarFiltro = "and a.Cmovimiento = 'S'">
</cfif>
<cfset LvarOrden = ''>
<cfif #valOrden.RecordCount# eq 0>
<cfset LvarOrden = "">
<cfelse>
	<cfif #valOrden.Pvalor# eq 'N'>
		<cfset LvarOrden = "and ctasSaldos.Ctipo <> 'O'">
	</cfif>
</cfif>

<cfoutput>
	<form action="#LvarAction#" method="post" name="form2" id="form2">
		<cfquery name="rsGEid" datasource="#Session.DSN#">
			select CAgrupador, Descripcion, Version,
				mge.GEid, age.GEnombre GrupoEmpresa
			from CEAgrupadorCuentasSAT ace
			left join CEMapeoGE mge
				on ace.CAgrupador = mge.Id_Agrupador
			left join AnexoGEmpresa age
				on mge.GEid = age.GEid
			where 1=1 and (ace.Ecodigo is null or ace.Ecodigo = #Session.Ecodigo#)
				and ace.CAgrupador = #form.CAgrupador#
		</cfquery>
		<!--- <cf_dump var="#rsGEid#"> --->
		<input type="hidden" name="GEid" id="GEid" value="<cfoutput>#rsGEid.GEid#</cfoutput>">
		<table align="left" cellpadding="0" cellspacing="2">

			<tr valign="baseline" >

				<td nowrap align="right"><strong><cf_translate key=LB_Nombre>Cuenta</cf_translate>:</strong>&nbsp;</td>
				<td style="vertical-align:bottom">
					   <cf_conlis
			          title="#LB_TitleCuentas#"
			          campos = "Cformato,Cdescripcion"
			          desplegables = "S,S"
			          modificables = "N,N"
			          size = "25,60"
			          valuesarray="#array_cuenta#"
			          tabla="(SELECT ctas.Ccuenta, ctas.Cformato, ctas.Cdescripcion, ctas.Ecodigo,ctas.Cmayor, ctas.PCDCniv,ctas.Ctipo
                              from ( select distinct a.Ccuenta, a.Cformato, a.Cdescripcion, a.Ecodigo,a.Cmayor, b.PCDCniv, cm.Ctipo
                              from CContables a
		                      inner join CtasMayor cm	on a.Cmayor = cm.Cmayor
                              INNER JOIN PCDCatalogoCuenta b on a.Ccuenta = b.Ccuentaniv
							  #PreserveSingleQuotes(LvarFiltro)#
                              ) ctas

	                          left join (select Ccuenta from CEInactivas	where Ecodigo = #Session.Ecodigo#
	                           and GEid = (SELECT  a.GEid FROM AnexoGEmpresa a
												inner join AnexoGEmpresaDet b
													on a.GEid = b.GEid
												where b.Ecodigo = #Session.Ecodigo#)) inc
	                          on inc.Ccuenta = ctas.Ccuenta where ctas.Ecodigo = #Session.Ecodigo# and inc.Ccuenta is null ) ctasSaldos
                              left join CEMapeoSAT cSAT on ctasSaldos.Ccuenta = cSAT.Ccuenta and cSAT.CAgrupador = '#trim(form.CAgrupador)#'
								 and cSAT.Ecodigo = ctasSaldos.Ecodigo"
			          columnas="distinct ctasSaldos.Cformato,ctasSaldos.Cdescripcion"
	    	          filtro="(cSAT.Ccuenta is null or GEid = -1) #PreserveSingleQuotes(LvarOrden)# order by ctasSaldos.Cformato"
			          desplegar="Cformato,Cdescripcion"
			          etiquetas="#LB_Descripcion#,#LB_Clasificacion#"
			          formatos="S,S"
			          align="left,left"
			          cortes=""
			          asignar="Cformato,Cdescripcion"
			          asignarformatos="S,S"
			          Funcion=""
			          MaxRowsQuery="1000"
			          Form="form2">
					<!---cf_conlis
			          title="Cuentas"
			          campos = "Cformato,Cdescripcion"
			          desplegables = "S,S"
			          modificables = "N,N"
			          size = "25,60"
			          valuesarray="#array_cuenta#"
			          tabla="CContables cco #PreserveSingleQuotes(LvarOrden)# "
			          columnas="cco.Cformato,cco.Cdescripcion "
	    	          filtro="Cformato NOT IN(Select Cformato from CEInactivas)
	    	                  and Cformato Not in (select cc.Cformato from  CContables cc
	    	                  inner join CEMapeoSAT ce on  cc.Ccuenta = ce.Ccuenta
	    	                  and ce.CAgrupador='#form.CAgrupador#' and ce.Ecodigo = #Session.Ecodigo#)
	    	                  #LvarFiltro#
	    	                  order by cco.Cformato"
			          desplegar="Cformato,Cdescripcion"
			          etiquetas="Descripci&oacute;n,Clasificacion"
			          formatos="S,S"
			          align="left,left"
			          cortes=""
			          asignar="Cformato,Cdescripcion"
			          asignarformatos="S,S"
			          Funcion=""
			          MaxRowsQuery="1000"
			          Form="form2"--->



				</td>
				<cfif MODOM EQ "ALTA">
					<td><input type="submit" value="+" class="btnNormal" style="font-family: Verdana; font-size: 11px; font-weight: bold;" title="#LB_TitleMas#" id="Subcuenta_cuenta" onclick="return funMapearCuentas(this.id)" name="Subcuenta_cuenta"></td>
				    <td><input type="submit" value="*" class="btnNormal" style="font-family: Verdana; font-size: 11px; font-weight: bold;" title="#LB_TitleMenos#" id="Subcuenta_subcuenta" onclick="return funMapearCuentas(this.id)" name="Subcuenta_subcuenta"></td>
				</cfif>
				<cfif MODOM NEQ "ALTA">
					<td><input type="radio" name="valm" id="cuenta" value="cuenta" title="#LB_TitleCuenta#"><label>+</label></td>
					<td><input type="radio" name="valm" id="subcuenta" value="subcuenta" title="#LB_TitleSubcuenta#"><label style="vertical-align: middle;">*</label></td>
				</cfif>

			</tr>
			<tr valign="baseline">
				<td colspan="2" align="center">
					<cfif modom NEQ 'ALTA'>
					     <input type="submit" name="Eliminar" value="#CMB_Eliminar#" class="btnEliminar" onclick="return funcBajaMapeo()">
					     <input type="submit" name="Regresar" value="#CMB_Regresar#" class="btnAnterior" onclick="Regresar()">
					</cfif>

				</td>
            </tr>

		</table>
		<input type="hidden" name="form.CCuentaSAT"  id="form.CCuentaSAT" value="">
		<input type="hidden" name="form.CAgrupador"  id="form.CAgrupador" value="">
		<cfif modom neq 'ALTA'>
			<input type="hidden" name="Ccuenta"  id="Ccuenta" value="#form.Ccuenta#">
			<input type="hidden" name="tipoME" id="tipoME" value="">
		</cfif>
		<input name="modom" id="modom" type="hidden" value="#modom#">
	</form>
</cfoutput>

<script language="javascript" type="text/javascript">
	<cfif modom neq 'ALTA'>
		document.getElementById('img_form2_Cformato').disabled = true;
		link = document.getElementById('img_form2_Cformato').href;
        document.getElementById('img_form2_Cformato').removeAttribute('href');
		<cfelse>
	    document.getElementById('img_form2_Cformato').disabled = false;
	    document.getElementById('testlink').setAttribute("javascript:doConlisCformato();",link);
	</cfif>
</script>

<script language="javascript" type="text/javascript">
		function funMapearCuentas(id){

			if(document.getElementById('Cformato').value == ""){
				alert('Seleccione una cuenta');
				return false;
			}else{

				document.getElementById("form.CCuentaSAT").value = document.getElementById("form1").elements[0].value
				document.getElementById("form.CAgrupador").value = document.getElementById("form1").elements[3].value
				return true;
			}
		}

	    function funcBajaMapeo(){
	    	var regresa = false;
	    	document.getElementById("form.CCuentaSAT").value = document.getElementById("form1").elements[0].value
			document.getElementById("form.CAgrupador").value = document.getElementById("form1").elements[3].value
			for(a=0;a<document.getElementsByName("valm").length;a++){
				if(document.getElementsByName("valm")[a].checked){
					document.getElementById("tipoME").value=document.getElementsByName("valm")[a].value
			    	regresa=true;
			    }
		    }
		    if(regresa == false){
		    	alert('Elija (+) solo esta cuenta o (*) esta cuanta y subcuentas asociadas');
		    }
		    if(regresa == true){
		    	if (confirm('¿Est\u00e1  seguro de eliminar esta cuenta del mapeo ?' )){
		    		regresa= true;
		        }else{
		        	 regresa= false;
		             }
		     }

              return regresa;
	    }

	    function Regresar(){
	    	document.getElementById("form.CCuentaSAT").value = document.getElementById("form1").elements[0].value
			document.getElementById("form.CAgrupador").value = document.getElementById("form1").elements[3].value
			document.getElementById("modom").value = 'ALTA'

	    }

</script>

