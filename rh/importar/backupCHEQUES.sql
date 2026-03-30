select coalesce(a.DRNnombre,'') + '' + coalesce(a.DRNapellido1,'') + '' + coalesce(a.DRNapellido2,'') as Nombre,
         substring(a.CBcc,1,3) as T_Cuenta,
         coalesce(a.CBcc,'-1') as N_Cuenta,
         1 as Subcuenta,
         1 as T_Saldo,
         a.DRNliquido as Monto,
         b.ERNdescripcion as Detalle,
         a.DRIdentificacion as Ref_1,
         coalesce(a.DRNnombre,'') + '' + coalesce(a.DRNapellido1,'') + '' + coalesce(a.DRNapellido2,'') as Ref_2,
         0 as Cod_Contable
from DRNomina a, ERNomina b
where a.ERNid=@ERNid
and a.Bid is null
and a.ERNid=b.ERNid