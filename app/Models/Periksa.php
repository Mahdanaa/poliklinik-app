<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Models\DaftarPoli;
use App\Models\DetailPeriksa;

class Periksa extends Model
{
    protected $table = 'periksa';

    protected $fillable = [
        'id_daftar_poli',
        'tgl_periksa',
        'catatan',
        'biaya_periksa'
    ];

    public function daftarPoli(){
        return $this->belongsTo(DaftarPoli::class, 'id_daftar_poli');
    }

    public function detailPeriksas(){
        return $this->hasMany(DetailPeriksa::class, 'id_periksa');
    }
}
