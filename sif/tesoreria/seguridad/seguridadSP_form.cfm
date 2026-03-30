<cfinvoke key="LB_Codigo" default="C&oacute;digo "	returnvariable="LB_Codigo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="seguridadSP_form.xml"/>
<cfinvoke key="LB_CentroFuncional" default="Centro Funcional"	returnvariable="LB_CentroFuncional"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="seguridadSP_form.xml"/>
<cfinvoke key="LB_Solicitante" default="Solicitante"	returnvariable="LB_Solicitante"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="seguridadSP_form.xml"/>
<cfinvoke key="LB_Aprobador" default="Aprobador"	returnvariable="LB_Aprobador"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="seguridadSP_form.xml"/>
<cfinvoke key="LB_MontoMaximo" default="Monto M&aacute;ximo"	returnvariable="LB_MontoMaximo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="seguridadSP_form.xml"/>
<cfinvoke key="LB_aAprobar" default="a Aprobar"	returnvariable="LB_aAprobar"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="seguridadSP_form.xml"/>
<cfinvoke key="LB_PuedeCambiar" default="Puede Cambiar"	returnvariable="LB_PuedeCambiar"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="seguridadSP_form.xml"/>
<cfinvoke key="LB_Tesoreria" default="Tesorer&iacute;a"	returnvariable="LB_Tesoreria"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="seguridadSP_form.xml"/>

<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfquery name="rsTESU" datasource="#Session.DSN#">
	select 
			  tu.Usucodigo, tu.CFid
			, tu.TESUSPsolicitante
			, tu.TESUSPaprobador
			, tu.TESUSPmontoMax
			, tu.TESUSPcambiarTES
			, tu.ts_rversion

			, u.Usulogin
			, dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2 as Usunombre

			, cf.CFcodigo, cf.CFdescripcion
			
	from TESusuarioSP tu
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
<form name="form1" action="seguridadSP_sql.cfm" method="post" onSubmit="javascript:if (window._finalizarform) _finalizarform();" style="margin:0;">
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
		</td>
    </tr>
	<tr><td>&nbsp;</td></tr>
	
	<tr>
		<td width="1%" nowrap><strong><cf_translate key=LB_SolicitanteU>Es Solicitante de Pago</cf_translate>:</strong>&nbsp;</td>
		<td>
			<input type="checkbox" name="TESUSPsolicitante" id="TESUSPsolicitante" value="1"
					<cfif rsTESU.TESUSPsolicitante NEQ "0">
						checked
					</cfif>
			/>
		</td>
	</tr>

	<tr>
		<td width="1%" nowrap><strong><cf_translate key=LB_AprobadorU>Es Aprobador de Solicitudes</cf_translate>:</strong>&nbsp;</td>
		<td>
			<input type="checkbox" name="TESUSPaprobador" id="TESUSPaprobador" value="1"
					<cfif rsTESU.TESUSPaprobador EQ "1">
						checked
					</cfif>
					onclick="
							if (this.checked)
							{
								this.form.TESUSPcambiarTES.disabled 		= false;

								document.getElementById('lblMonto').style.visibility = 'visible';
								this.form.TESUSPmontoMax.tabIndex 			= 0;
								this.form.TESUSPmontoMax.readOnly			= false;
								this.form.TESUSPmontoMax.style.border		= window.Event ? '' : 'inset 2px';
								this.form.TESUSPmontoMax.style.backGround	= '';
							}
							else
							{
								this.form.TESUSPcambiarTES.disabled 		= true;
								this.form.TESUSPcambiarTES.checked	 		= false;

								document.getElementById('lblMonto').style.visibility = 'hidden';
								this.form.TESUSPmontoMax.value	 			= '';
								this.form.TESUSPmontoMax.tabIndex 			= -1;
								this.form.TESUSPmontoMax.readOnly			= true;
								this.form.TESUSPmontoMax.style.border		= 'solid 1px ##CCCCCC';
								this.form.TESUSPmontoMax.style.backGround	= 'inherit';
							}
						"
			/>
		</td>
	</tr>

	<tr>
		<td width="1%" nowrap><strong>&nbsp;- <cf_translate key=LB_MontoMaximo>Monto Máximo a Aprobar</cf_translate>:</strong>&nbsp;</td>
		<td>
			<cfif rsTESU.TESUSPaprobador NEQ "1" OR rsTESU.TESUSPmontoMax EQ 0>
				<cfset rsTESU.TESUSPmontoMax = "">
			</cfif>
			<cf_inputNumber name="TESUSPmontoMax" enteros=13 decimales=2 readonly="#rsTESU.TESUSPaprobador NEQ '1'#" value="#rsTESU.TESUSPmontoMax#"/>
			<span id="lblMonto" <cfif rsTESU.TESUSPaprobador NEQ '1'>style="visibility:hidden;"</cfif>>
			(<cf_translate key=LB_Limite>En blanco no tiene límite de aprobación</cf_translate>)
			</span>
		</td>
	</tr>

	<tr>
		<td width="1%" nowrap><strong>&nbsp;- <cf_translate key=LB_CambiarTesoreria>Puede cambiar la Tesorería de Pago</cf_translate>:</strong>&nbsp;</td>
		<td>
			<input type="checkbox" name="TESUSPcambiarTES" id="TESUSPcambiarTES" value="1"
					<cfif rsTESU.TESUSPaprobador NEQ "1">
						disabled
					<cfelseif rsTESU.TESUSPcambiarTES EQ "1">
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
	<cf_botones  regresar='seguridadSP.cfm' modo='CAMBIO'>
<cfelse>
	<cf_botones  regresar='seguridadSP.cfm' modo='ALTA'>
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
				<strong><cf_translate key=LB_ListaCentrosFuncionales>Lista de Centros Funcionales del Usuario</cf_translate></strong>
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
					when tu.TESUSPsolicitante = 1 
						then '#PreserveSingleQuotes(LvarImgChecked)#'
						else '#PreserveSingleQuotes(LvarImgUnChecked)#'
				  end as Solicitante
				, case
					when tu.TESUSPaprobador = 1 
						then '#PreserveSingleQuotes(LvarImgChecked)#'
						else '#PreserveSingleQuotes(LvarImgUnChecked)#'
				  end as Aprobador
				, case 
					when tu.TESUSPaprobador = 1 AND tu.TESUSPmontoMax <> 0 
						then tu.TESUSPmontoMax 
				  end as montoMaximo
				, case 
					when tu.TESUSPcambiarTES = 1 
						then '#PreserveSingleQuotes(LvarImgChecked)#'
						else '#PreserveSingleQuotes(LvarImgUnChecked)#'
				  end as CambiarTES
		from TESusuarioSP tu
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
		<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_CentroFuncional#,#LB_Solicitante#, #LB_Aprobador#, #LB_MontoMaximo#<BR>#LB_aAprobar#, #LB_PuedeCambiar#<BR>#LB_Tesoreria#"/> 
		<cfinvokeargument name="formatos" value="S,S,S,S,M,S"/> 
		<cfinvokeargument name="align" value="left,left,center,center,right,center"/> 
		<cfinvokeargument name="ajustar" value="N"/> 
		<cfinvokeargument name="checkboxes" value="N"/> 
		<cfinvokeargument name="keys" value="CFid,Usucodigo"/>
		<cfinvokeargument name="irA" value="seguridadSP.cfm"/> 
		<cfinvokeargument name="showlink" value="yes"/>
		<cfinvokeargument name="usaAJAX" value="yes"/> 
		<cfinvokeargument name="conexion" value="#Session.DSN#"/> 
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
