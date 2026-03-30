<cfset LvarTitulo = "Administración de Asientos de Contabilidad V.3 -  Meses Cerrados">
<cf_templateheader title="#LvarTitulo#">
	<cf_web_portlet_start titulo="#LvarTitulo#" width="50%">
		<cfinvoke component="sif.Componentes.pListas" method="pLista"
			tabla="CGV3cierres cc"
			columnas="Eperiodo, Emes, Mstatus, 2 as Nivel,
				convert(varchar(4),Eperiodo) +
				case Emes
					when  1 then ' - ENE'
					when  2 then ' - FEB'
					when  3 then ' - MAR'
					when  4 then ' - ABR'
					when  5 then ' - MAY'
					when  6 then ' - JUN'
					when  7 then ' - JUL'
					when  8 then ' - AGO'
					when  9 then ' - SET'
					when 10 then ' - OCT'
					when 11 then ' - NOV'
					when 12 then ' - DIC'
				end as Mes,
				case Mstatus
					when 0	then 'Cargando...'
					when 1	then 'Cargado'
					when -1	then '<font color=""##FF0000""><strong>Cargado con errores</strong></font>'
					when 2	then 'Generando Cuentas...'
					when 3	then 'Cuentas Generadas'
					when -3	then '<font color=""##FF0000""><strong>Cuentas con errores</strong></font>'
					when 4	then 'Generando y Aplicando Asientos...'
					when 5	then '<strong>Todas las Pólizas Contabilizadas</strong>'
					when -5	then '<font color=""##FF0000""><strong>Asientos con error</strong></font>'
				end as Estado,
				(select count(1) from CGV3asientos where Ecodigo=cc.Ecodigo and Eperiodo=cc.Eperiodo and Emes=cc.Emes) as Asientos,

				case 
					when Mstatus =  1 then ' <img src=""/cfmx/sif/imagenes/options.small.png"" style=""cursor:pointer;"" title=""Procesar"" onclick=""sbProcesar(' + convert(varchar(4),Eperiodo) + ',' + convert(varchar(2),Emes) + ');"">' 
					when Mstatus = -3 then ' <img src=""/cfmx/sif/imagenes/Cferror.gif"" style=""cursor:pointer;"" title=""Ver Cuentas con Errores"" onclick=""sbCuentas(' + convert(varchar(4),Eperiodo) + ',' + convert(varchar(2),Emes) + ');"">' 
				end	as  OP
			"
			filtro="Ecodigo = #session.Ecodigo#"
			desplegar="OP, Mes, Estado, Asientos"
			etiquetas=" , Período - Mes, Estado, Asientos"
			formatos="S,S,S,S"
			align="left,left,left,right"
			ajustar="false"
			showLink="yes"
			showEmptyListMsg="yes"
			ira="CGV3conta.cfm"
			navegacion="#navegacion#"
			keys="Eperiodo,Emes"
			formName="formCierres"
		/>		
	<cf_web_portlet_end>
<cf_templatefooter>
<script language="javascript">
	function sbCuentas(p,m)
	{
		document.formCierres.nosubmit = true;
		location.href="CGV3conta.cfm?Nivel=4&Eperiodo="+p+"&Emes="+m;
	}
	function sbProcesar(p,m)
	{
		document.formCierres.nosubmit = true;
		location.href="CGV3conta_sql.cfm?OP=CT&Nivel=2&Eperiodo="+p+"&Emes="+m;

	}
</script>