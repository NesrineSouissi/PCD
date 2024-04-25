<?php

namespace App\Http\Controllers;
use App\Models\User;
use Illuminate\Support\Facades\Auth; 

use Illuminate\Http\Request;

class Homecontroller extends Controller
{
    public function redirect(){
       $usertype=Auth::user()->usertype; 
       if($usertype==1){
        return view('admin.home');
       }
       else{
        return view('home.userpage');
       }
    }
    public function index(){
       
         return view('home.userpage');
        
     }
     public function aboutus(){
        return view('home.aboutus');
     }
     public function services(){
      return view('home.services');
   }
}
