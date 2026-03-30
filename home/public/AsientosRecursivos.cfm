<cfinvoke component="sif.Componentes.Contabilidad" method="fnGeneraAsientosRecursivos" 
	Empresa="#Session.Ecodigo#" 
	MesAnterior="1" 
	PeriodoAnterior="2009"
	MesActual="1"
	PeriodoActual="2009"
	Conexion="minisif">
</cfinvoke>
<cfoutput>Terminó</cfoutput>