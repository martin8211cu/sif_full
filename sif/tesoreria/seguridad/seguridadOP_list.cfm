<cfinvoke key="LB_Nombre" default="Nombre"	returnvariable="LB_Nombre"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="seguridadOP.xml"/>
<cfinvoke key="LB_Usuario" default="Usuario"	returnvariable="LB_Usuario"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="seguridadOP.xml"/>
<cfinvoke key="MSG_DeseaBorrarUsu" default="¿Desea borrar al usuario"	returnvariable="MSG_DeseaBorrarUsu"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="seguridadOP.xml"/>

<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<form name="formList" method="post" action="seguridadOP.cfm">
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td nowrap="nowrap" class="tituloListas">
				<strong><cf_translate key=LB_Tesoreria>Tesorería</cf_translate>:</strong>
			</td>

			<td class="tituloListas">
				<cf_cboTESid tipo="" onChange="this.form.submit();" tabindex="1">
			</td>
			<td width="1000" class="tituloListas">
				&nbsp;&nbsp;&nbsp;
			</td>
		</tr>
	</table>
	<cf_dbfunction name="to_char" args="tu.Usucodigo" returnVariable="LvarUsucodigo">
	<cfset LvarImgChecked	= "'<img border=""0"" src=""/cfmx/sif/imagenes/borrar01_S.gif"" style=""cursor:pointer;"" onClick=""sbBaja(' #LvarCNCT# #LvarUsucodigo# #LvarCNCT# ');"">'">
	<cfinvoke component="sif.Componentes.pListas" method="pLista"
		tabla="
				TESusuarioOP tu
					inner join Usuario u
						inner join DatosPersonales dp
						   on dp.datos_personales = u.datos_personales
						on u.Usucodigo = tu.Usucodigo
				"
		columnas="
				  tu.TESid, tu.Usucodigo
				, u.Usulogin
				, dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2 as Usuario
				, #preserveSingleQuotes(LvarImgChecked)# as borrar
			"
		filtro="tu.TESid = #session.Tesoreria.TESid# order by u.Usulogin"
		desplegar="borrar, Usulogin, Usuario"
		etiquetas=" ,#LB_Usuario#, #LB_Nombre#"
		formatos="U,S,S"
		align="left,left,left"
		ira="seguridadOP.cfm"
		form_method="post"
		keys="Usulogin"
		showLink="no"
		incluyeForm="no"
		formName="formList"
	
		mostrar_filtro="yes"
		filtrar_automatico="yes"
		filtrar_Por=" , Usulogin, dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2"
	/>
</form>
<cfoutput>
<script language="javascript">
	function sbBaja(Usucodigo)
	{
		if (confirm("#MSG_DeseaBorrarUsu#?"))
		{
			location.href = "seguridadOP_sql.cfm?btnBaja&usucodigo=" + Usucodigo;
		}
		return false;
	}
</script>
</cfoutput>