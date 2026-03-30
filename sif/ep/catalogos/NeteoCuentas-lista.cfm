
<cfif isdefined("Form.fID_Neteo") and Len(Trim(Form.fID_Neteo))>
<cfquery name="rsNeteo" datasource="#Session.DSN#">
    select cn.ID_Neteo,cn.Cuenta1,cn.Cuenta2,
				 case signo1
					when -1 then 'Credito'
					when 1 then 'Debito'
					else ''
				 end Balance1,
				 case signo2
					when -1 then 'Credito'
					when 1 then 'Debito'
					else ''
				 end Balance2,
				 c1.Cformato Cformato1, c1.Cdescripcion Cdescripcion1,
				 c2.Cformato Cformato2, c2.Cdescripcion Cdescripcion2
				from CGEstrProgCtasNeteo cn
				<cfif tipoCuenta EQ "1" >
					left join CContables c1
						on cn.Cuenta1 = c1.Ccuenta
					left join CContables c2
						on cn.Cuenta2 = c2.Ccuenta
				<cfelse>
					left join (select CPcuenta, CPformato Cformato, CPdescripcion Cdescripcion  from CPresupuesto) c1
						on cn.Cuenta1 = c1.CPcuenta
					left join (select CPcuenta, CPformato Cformato, CPdescripcion Cdescripcion  from CPresupuesto) c2
						on cn.Cuenta2 = c2.CPcuenta
				</cfif>
				where cn.TipoAplica = #tipoCuenta#
					and cn.ID_Estr = #Form.fID_Estr#
					and cn.ID_Neteo = #Form.fID_Neteo#
</cfquery>
</cfif>

<cfset filtro = "">

<cfif isdefined("Form.fID_Estr") and Len(Trim(Form.fID_Estr))>
	<cfset filtro = filtro & " and ID_Estr = " & Form.fID_Estr>
</cfif>
<cfif isdefined("Form.fID_Neteo") and Len(Trim(Form.fID_Neteo))>
	<cfset filtro = filtro & " and ID_Neteo = " & Form.fID_Neteo>
</cfif>

<cfoutput>
<cfset campos = "">

<form name="filtro7" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0;">
	<input type="hidden" name="fID_Neteo" value="<cfif isdefined ("form.fID_Neteo") and len(trim(form.fID_Neteo))><cfoutput>#form.fID_Neteo#</cfoutput></cfif>">
	<input type="hidden" name="fID_Estr" value="<cfif isdefined ("form.fID_Estr") and len(trim(form.fID_Estr))><cfoutput>#form.fID_Estr#</cfoutput></cfif>">
	<input name="tab" type="hidden" value="2">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td class="tituloAlterno" align="center" style="text-transform: uppercase; ">
			<strong>Neteo entre Cuentas</strong>
		</td>
      </tr>
	  <tr>
		<td valign="top">
			<cfif len(campos) gt 0>
				<cfif mid(trim(campos),len(trim(campos)),1) eq "," >
					<cfset campos = "," & mid(trim(campos),1,(len(trim(campos))-1)) & " ">
				<cfelse>
					<cfset campos = "," & campos & " ">
				</cfif>
			</cfif>
			<cfset params = '?tab=2'>
			<cfif isdefined("Form.ID_Estr") and Len(Trim(Form.ID_Estr))>
                <cfset params = params & " &ID_Estr = " & Form.ID_Estr>
            </cfif>

			<cfset tbe=" CGEstrProgCtasNeteo cn">
				<cfif tipoCuenta EQ "1" >
					<cfset tbe= tbe & " left join CContables c1 on cn.Cuenta1 = c1.Ccuenta left join CContables c2 on cn.Cuenta2 = c2.Ccuenta">
				<cfelse>
					<cfset tbe= tbe & " left join (select CPcuenta, CPformato Cformato, CPdescripcion Cdescripcion  from CPresupuesto) c1 on cn.Cuenta1 = c1.CPcuenta left join (select CPcuenta, CPformato Cformato, CPdescripcion Cdescripcion  from CPresupuesto) c2 on cn.Cuenta2 = c2.CPcuenta">
				</cfif>

			<cfinvoke
				component="sif.Componentes.pListas"
				method="pLista"
				returnvariable="pListaNeteo"
				columnas="ID_Estr,cn.ID_Neteo,cn.Cuenta1,cn.Cuenta2,
				 case signo1
					when -1 then 'Credito'
					when 1 then 'Debito'
					else ''
				 end Balance1,
				 case signo2
					when -1 then 'Credito'
					when 1 then 'Debito'
					else ''
				 end Balance2,
				 c1.Cformato Cformato1, c1.Cdescripcion Cdescripcion1,
				 c2.Cformato Cformato2, c2.Cdescripcion Cdescripcion2"
				tabla="#tbe#"
				filtro="cn.TipoAplica = #tipoCuenta# and cn.ID_Estr = #Form.fID_Estr#  order by ID_Neteo"
				desplegar="Cuenta1,Cformato1,Balance1,Cuenta2,Cformato2,Balance2"
				etiquetas="Formato,Descripci&oacute;n,Balance,Formato,Descripci&oacute;n,Balance"
				formatos="S,S,S,S,S,S"
				align="left, left, left, left, left, left"
				checkboxes="N"
				ira="NeteoCuentas-form.cfm&tab=2"
				nuevo="NeteoCuentas-form.cfm&tab=2"
				formname="filtro7"
				showLink="true"
				showemptylistmsg="true"
				incluyeform="true"
				keys="ID_Neteo,ID_Estr"
				filtrar_automatico="true"
				filtrar_por="ID_Neteo"
				maxrows="15"
				navegacion="#navegacion#&tab=2"
				/>
			</td>
	  </tr>
	  <tr>
	    <td>&nbsp;</td>
      </tr>
	</table>
</form>
</cfoutput>

