<cfinvoke component="sif.an.operacion.calculo.calculo" 
		method="distribuir"

		returnvariable="LvarEnviados"

		DataSource	= "#url.DSN#"
		AnexoId		= "#url.AnexoId#"
		ACid		= "#url.ACid#"
/>
<cfoutput>Enviados=#LvarEnviados#</cfoutput>
