
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfquery name="rsTESU" datasource="#Session.DSN#">
	select 
			  tu.Usucodigo, tu.CFid
			, tu.TESUGEsolicitante
			, tu.TESUGEaprobador
			, tu.TESUGEmontoMax
			, tu.TESUGEcambiarTES
			, tu.ts_rversion

			, u.Usulogin
			, dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2 as Usunombre

			, cf.CFcodigo, cf.CFdescripcion
			
	from TESusuarioGE tu
		inner join Usuario u
			inner join DatosPersonales dp
			   on dp.datos_personales = u.datos_personales
			on u.Usucodigo = tu.Usucodigo
		inner join CFuncional cf
			on cf.CFid = tu.CFid
	where tu.CFid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#" null="#form.CFid EQ ""#">
	  and tu.Usucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#" null="#form.Usucodigo EQ ""#">
</cfquery>

<cfquery name="rsU" datasource="#Session.DSN#">
	select 
			  u.Usucodigo, u.Usulogin
			, dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2 as Usunombre
	from Usuario u
			inner join DatosPersonales dp
			   on dp.datos_personales = u.datos_personales
	where u.Usucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#" null="#form.Usucodigo EQ ""#">
</cfquery>

<cfoutput>
<form name="form1" action="seguridadGE_sql.cfm" method="post" onSubmit="javascript:if (window._finalizarform) _finalizarform();" style="margin:0;">
<table width="99%%"  border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td width="1%" nowrap><strong><cf_translate key=LB_Usuario>Usuario</cf_translate>:</strong></td>
		<td>
			<cf_sifusuario conlis="true" query="#rsU#" size="40" readonly="#form.usucodigo NEQ ""#">
		</td>
	</tr>
	<tr>
		<td width="1%" nowrap><strong><cf_translate key=LB_CentroFuncional>Centro Funcional</cf_translate>:</strong>&nbsp;</td>
		<td>
			<cf_rhcfuncional query="#rsTESU#"  readonly="#rsTESU.recordCount NEQ 0#">
			<cfif rsTESU.recordCount NEQ 0 and modo NEQ "ALTA">
            	<input type="hidden" name="CFid" value="#rsTESU.CFid#" />
            </cfif>
		</td>
	</tr>

	<tr><td>&nbsp;</td></tr>
	
	<tr>
		<td width="1%" nowrap><strong><cf_translate key=LB_SolicitanteU>Es Solicitante de Anticipos y  Liquidaciones</cf_translate>:</strong>&nbsp;</td>
		<td>
			<input type="checkbox" name="TESUGEsolicitante" id="TESUGEsolicitante" value="1"
					<cfif rsTESU.TESUGEsolicitante EQ "1">
						checked
					</cfif>
			/>
		</td>
	</tr>

	<tr>
		<td width="1%" nowrap><strong><cf_translate key=LB_AprobadorU>Es Aprobador de Liquidaciones</cf_translate>:</strong>&nbsp;</td>
		<td>
			<input type="checkbox" name="TESUGEaprobador" id="TESUGEaprobador" value="1"
					<cfif rsTESU.TESUGEaprobador EQ "1">
						checked
					</cfif>
					onclick="
							if (this.checked)
							{
								this.form.TESUGEcambiarTES.disabled 		= false;

								document.getElementById('lblMonto').style.visibility = 'visible';
								this.form.TESUGEmontoMax.tabIndex 			= 0;
								this.form.TESUGEmontoMax.readOnly			= false;
								this.form.TESUGEmontoMax.style.border		= window.Event ? '' : 'inset 2px';
								this.form.TESUGEmontoMax.style.backGround	= '';
							}
							else
							{
								this.form.TESUGEcambiarTES.disabled 		= true;
								this.form.TESUGEcambiarTES.checked	 		= false;

								document.getElementById('lblMonto').style.visibility = 'hidden';
								this.form.TESUGEmontoMax.value	 			= '';
								this.form.TESUGEmontoMax.tabIndex 			= -1;
								this.form.TESUGEmontoMax.readOnly			= true;
								this.form.TESUGEmontoMax.style.border		= 'solid 1px ##CCCCCC';
								this.form.TESUGEmontoMax.style.backGround	= 'inherit';
							}
						"
			/>
		</td>
	</tr>

	<tr>
		<td width="1%" nowrap><strong>&nbsp;- <cf_translate key=LB_MontoMaximo>Monto Máximo a Aprobar:</cf_translate>&nbsp;</td>
		<td>
			<cfif rsTESU.TESUGEaprobador NEQ "1" OR rsTESU.TESUGEmontoMax EQ 0>
				<cfset rsTESU.TESUGEmontoMax = "">
			</cfif>
			<cf_inputNumber name="TESUGEmontoMax" enteros=13 decimales=2 readonly="#rsTESU.TESUGEaprobador NEQ '1'#" value="#rsTESU.TESUGEmontoMax#"/>
			<span id="lblMonto" <cfif rsTESU.TESUGEaprobador NEQ '1'>style="visibility:hidden;"</cfif>>
			(<cf_translate key=LB_EnBlancoNoLimiteAprob>En blanco no tiene límite de aprobación:</cf_translate>)
			</span>
		</td>
	</tr>

	<tr>
		<td width="1%" nowrap><strong>&nbsp;- <cf_translate key=LB_CambiarTesoreria>Puede cambiar la Tesorería de Pago</cf_translate>:</strong>&nbsp;</td>
		<td>
			<input type="checkbox" name="TESUGEcambiarTES" id="TESUGEcambiarTES" value="1"
					<cfif rsTESU.TESUGEaprobador NEQ "1">
						disabled
					<cfelseif rsTESU.TESUGEcambiarTES EQ "1">
						checked
					</cfif>
			/>
		</td>
	</tr>
</table>
<br>
<cfif rsTESU.usucodigo NEQ "">
	<cfinvoke 	component="sif.Componentes.DButils" 
				method="toTimeStamp" 
				returnvariable="ts"
				arTimeStamp="#rsTESU.ts_rversion#"/>
	<input type="hidden" name="ts_rversion" value="#ts#">	
	<cf_botones  regresar='seguridadGE.cfm' modo='CAMBIO'>
<cfelse>
	<cf_botones  regresar='seguridadGE.cfm' modo='ALTA'>
</cfif>
</form>
<cf_qforms form="form1" objForm="LobjQForm_TESU">
	<cf_qformsRequiredField args="Usulogin, Código de Usuario">
	<cf_qformsRequiredField args="CFcodigo, Centro Funcional">
</cf_qforms>
<cfif form.Usucodigo NEQ "">
	<BR>
	<table width="100%">
		<tr>
			<td width="1%" nowrap="nowrap" align="left" style="border-bottom: 1px solid black;	padding-bottom: 5px;">
				<strong>Lista de Centros Funcionales del Usuario</strong>
			</td>
			<td>&nbsp;</td>
		</tr>
	</table>

	<cfset LvarImgChecked  	 = "<img border=""0"" src=""/cfmx/sif/imagenes/checked.gif"">">
	<cfset LvarImgUnchecked	 = "<img border=""0"" src=""/cfmx/sif/imagenes/unchecked.gif"">">

	<cfquery name="rsListaCFXSolicitud" datasource="#session.DSN#">
		select 
				  tu.CFid, tu.Usucodigo
				
				, cf.CFcodigo, cf.CFdescripcion
				, case
					when tu.TESUGEsolicitante = 1 
						then '#PreserveSingleQuotes(LvarImgChecked)#'
						else '#PreserveSingleQuotes(LvarImgUnChecked)#'
				  end as Solicitante
				, case
					when tu.TESUGEaprobador = 1 
						then '#PreserveSingleQuotes(LvarImgChecked)#'
						else '#PreserveSingleQuotes(LvarImgUnChecked)#'
				  end as Aprobador
				, case 
					when tu.TESUGEaprobador = 1 AND tu.TESUGEmontoMax <> 0 
						then tu.TESUGEmontoMax 
				  end as montoMaximo
				, case 
					when tu.TESUGEcambiarTES = 1 
						then '#PreserveSingleQuotes(LvarImgChecked)#'
						else '#PreserveSingleQuotes(LvarImgUnChecked)#'
				  end as CambiarTES
		from TESusuarioGE tu
			inner join CFuncional cf
				on cf.CFid = tu.CFid
		where tu.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
		  and tu.Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet"> 
		<cfinvokeargument name="query" value="#rsListaCFXSolicitud#"/> 
		<cfinvokeargument name="desplegar" value="CFcodigo, CFdescripcion, Solicitante, Aprobador, MontoMaximo, CambiarTES"/> 
		<cfinvokeargument name="etiquetas" value="Código,Centro Funcional,Solicitante, Aprobador, Monto Maximo<BR>a Aprobar, Puede Cambiar<BR>Tesorería"/> 
		<cfinvokeargument name="formatos" value="S,S,S,S,M,S"/> 
		<cfinvokeargument name="align" value="left,left,center,center,right,center"/> 
		<cfinvokeargument name="ajustar" value="N"/> 
		<cfinvokeargument name="checkboxes" value="N"/> 
		<cfinvokeargument name="keys" value="CFid,Usucodigo"/>
		<cfinvokeargument name="irA" value="seguridadGE.cfm"/> 
		<cfinvokeargument name="showlink" value="yes"/> 
	</cfinvoke> 
</cfif>
</cfoutput>
<!--- Validaciones con QFORMS, Otras Validaciones y Funciones en General --->
<script language="JavaScript" type="text/javascript">	
	function funcEliminar(cf){
		if (!confirm('¿Desea eliminar el centro funcional de esta relación?')) return false;
		document.form1.CFid.value=cf;
		document.form1.Baja.value=1;
		document.form1.submit();
		return false;
	}
	
	function funcChecked(cf, type, value){
		document.form1.CFid.value=cf;
		document.form1.CheckedType.value=type;
		document.form1.CheckedValue.value=value;
		document.form1.submit();
		return false;
	}
</script>
