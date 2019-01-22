var express = require('express');
var router = express.Router();
var connection = require('../models/model');
var middleware = require('../middleware/index');

router.get("/add_tool", middleware.isClerkLoggedIn, function(req, res) {
    res.render("add_tool");
});

router.post("/add_tool", middleware.isClerkLoggedIn, function(req, res, next){
    if (req.body.length_unit === "inch") {
        var width = parseFloat(req.body.width) + parseFloat(req.body.width_fraction);
    } else if (req.body.length_unit === "feet"){
        var width = 12 * (parseFloat(req.body.width) + parseFloat(req.body.width_fraction));
    }
    if (req.body.length_unit === "inch") {
        var length = parseFloat(req.body.length) + parseFloat(req.body.length_fraction);
    } else if (req.body.length_unit === "feet"){
        var length = 12 * (parseFloat(req.body.length) + parseFloat(req.body.length_fraction));
    }
    var insertTool = "INSERT INTO tool SET ?";
    if (req.body.power_source === "manual") {
        var manual_tool ={
            original_price: parseFloat(req.body.purchase_price),
            power_source: req.body.power_source,
            manufacturer: req.body.manufacturer,
            sub_option: req.body.sub_option,
            sub_type: req.body.sub_type,
            material: req.body.material,
            width: width,
            length: length,
            weight: parseFloat(req.body.weight),
            type: req.body.tool_type
        }
        connection.query(insertTool, manual_tool, function(err,result) {
            if (err) {
                console.error("SQL connection error", err);
                return next.err;
            }
            console.log(result.insertId);
            var manual_toolId = result.insertId;
            var manual_subtype = req.body.sub_type;
            if (manual_subtype === "screwdriver") {
                var tool_sub_type = {
                    ToolID: manual_toolId,
                    screw_size: req.body.screw_size
                }
            } else if (manual_subtype === "socket") {
                var tool_sub_type = {
                    ToolID: manual_toolId,
                    deep_socket: req.body.deep_socket,
                    drive_size: parseFloat(req.body.drive_size),
                    sae_size: parseFloat(req.body.sae_size)
                }
            } else if (manual_subtype === "ratchet") {
                var tool_sub_type = {
                    ToolID: manual_toolId,
                    drive_size: parseFloat(req.body.drive_size)
                }
            } else if (manual_subtype === "wrench") {
                var tool_sub_type = {
                    ToolID: manual_toolId,
                    drive_size: parseFloat(req.body.drive_size)
                }
            } else if (manual_subtype === "plier") {
                var tool_sub_type = {
                    ToolID: manual_toolId,
                    adjustable: req.body.adjustable
                }
            } else if (manual_subtype === "gun") {
                var tool_sub_type = {
                    ToolID: manual_toolId,
                    gauge_rating: parseInt(req.body.gauge_rating),
                    capacity: parseInt(req.body.capacity)
                }
            } else if (manual_subtype === "hammer") {
                var tool_sub_type = {
                    ToolID: manual_toolId,
                    anti_vibration: req.body.anti_vibration
                }
            } else if (manual_subtype === "digger") {
                var tool_sub_type = {
                    ToolID: manual_toolId,
                    handle_material: req.body.handle_material,
                    blade_width: parseFloat(req.body.blade_width),
                    blade_length: parseFloat(req.body.blade_length),
                }
            } else if (manual_subtype === "pruner") {
                var tool_sub_type = {
                    ToolID: manual_toolId,
                    handle_material: req.body.handle_material,
                    blade_material: req.body.blade_material,
                    blade_length: parseFloat(req.body.blade_length)
                }
            } else if (manual_subtype === "rakes") {
                var tool_sub_type = {
                    ToolID: manual_toolId,
                    handle_material: req.body.handle_material,
                    tine_count:req.body.tine_count
                }
            } else if (req.body.sub_type === "wheelbarrows") {
                var tool_sub_type = {
                    ToolID: manual_toolId,
                    handle_material: req.body.handle_material,
                    bin_material:req.body.bin_material,
                    bin_volume:req.body.bin_volume,
                    wheel_count:req.body.wheel_count
                }
            } else if (manual_subtype === "striking") {
                var tool_sub_type = {
                    ToolID: manual_toolId,
                    handle_material: req.body.handle_material,
                    head_weight:req.body.head_weight
                }
            } else if (manual_subtype === "straight") {
                var tool_sub_type = {
                    ToolID: manual_toolId,
                    rubber_feet: req.body.rubber_feet,
                    step_count:req.body.step_count,
                    weight_capacity: req.body.weight_capacity
                }
            } else if (manual_subtype === "step") {
                var tool_sub_type = {
                    ToolID: manual_toolId,
                    pail_shelf: req.body. pail_shelf,
                    step_count:req.body.step_count,
                    weight_capacity: req.body.weight_capacity
                }
            }
            var manual_toolInert = "INSERT INTO " + manual_subtype + " SET ?";
            connection.query(manual_toolInert, tool_sub_type, function (err, result) {
                if (err) {
                    console.error("SQL connection error", err);
                    return next.err;
                }
                console.log("manual tool of sub type: " + manual_subtype +" inserted");
            })
        })
    } else {
        var nonManualTool ={
            original_price: parseFloat(req.body.purchase_price),
            power_source: req.body.power_type,
            manufacturer: req.body.manufacturer,
            sub_option: req.body.sub_option,
            sub_type: req.body.sub_type,
            material: req.body.material,
            width: width,
            length: length,
            weight: parseFloat(req.body.weight),
            type: req.body.tool_type
        };
        var power_subtype = req.body.sub_type;
        var insertPower = "INSERT INTO powertool SET ?";
        var insertAccessory = "INSERT INTO accessory SET ?";
        var insertCordless = "INSERT INTO cordless SET ?";
        var insert_power_subtype = "INSERT INTO " + power_subtype + " SET ?";
        connection.query(insertTool, nonManualTool, function(err,result) {
            if (err) {
                console.error("SQL connection error", err);
                return next.err;
            }
            console.log("Power tool ID: " + result.insertId);
            var insertPowerToolId = result.insertId;

            //insert power tool
            var powerTool = {
                toolID: insertPowerToolId,
                amp_rating: req.body.amp_rating,
                min_rpm_rating: req.body.min_rpm_rating,
                volt_rating: req.body.volt_rating,
                max_rpm_rating: req.body.min_rpm_rating,
            }
            connection.query(insertPower, powerTool, function(err,result) {
                if (err) {
                    console.error("SQL connection error", err);
                    return next.err;
                }
                console.log("Power tool inserted");
            });

            //insert accessory
            var accessary = {
                toolID: insertPowerToolId,
                AccessoryName: req.body.accessory_description,
                accessory_quantity: req.body.accessory_quantity
            }
            connection.query(insertAccessory, accessary, function(err,result) {
                if (err) {
                    console.error("SQL connection error", err);
                    return next.err;
                }
                console.log("Accessory inserted");
            });

            // if cordless
            if (req.body.power_source ==="cordless") {
                var cordlessTool = {
                    battery_type: req.body.battery_type
                }
                connection.query(insertCordless, cordlessTool, function (err, result) {
                    if (err) {
                        console.error("SQL connection error", err);
                        return next.err;
                    }
                    console.log(result.insertId);
                    var insertedCordlessId = result.insertId;
                    if (power_subtype === "drill") {
                        var cordless_drill_tool = {
                            ToolID: insertPowerToolId,
                            min_torque_rating: req.body.min_torque_rating,
                            max_torque_rating: req.body.max_torque_rating,
                            adjustable_clutch: req.body.adjustable_clutch,
                            CordlessID: insertedCordlessId
                        }
                        connection.query(insert_power_subtype, cordless_drill_tool, function (err) {
                            if (err) {
                                console.error("SQL connection error", err);
                                return next.err;
                            }
                            console.log("Cordless Drill inserted");
                        })
                    } else if (power_subtype === "saw") {
                        var cordless_saw_tool = {
                            ToolID: insertPowerToolId,
                            blade_size: req.body.blade_size,
                            CordlessID: insertedCordlessId
                        }
                        connection.query(insert_power_subtype, cordless_saw_tool, function (err) {
                            if (err) {
                                console.error("SQL connection error", err);
                                return next.err;
                            }
                            console.log("Cordless Saw inserted");
                        })
                    } else if (power_subtype === "sander") {
                        var cordless_sander_tool = {
                            ToolID: insertPowerToolId,
                            dust_bag: req.body.dust_bag,
                            CordlessID: insertedCordlessId
                        }
                        connection.query(insert_power_subtype, cordless_sander_tool, function (err) {
                            if (err) {
                                console.error("SQL connection error", err);
                                return next.err;
                            }
                            console.log("Cordless Sander inserted");
                        })
                    }
                })
            } else {
                if (power_subtype === "drill") {
                    var drill_tool = {
                        ToolID: insertPowerToolId,
                        min_torque_rating: req.body.min_torque_rating,
                        max_torque_rating: req.body.max_torque_rating,
                        adjustable_clutch: req.body.adjustable_clutch
                    }
                    connection.query(insert_power_subtype, drill_tool, function (err) {
                        if (err) {
                            console.error("SQL connection error", err);
                            return next.err;
                        }
                        console.log("Electric Drill inserted");
                    })
                } else if (power_subtype === "saw") {
                    var saw_tool = {
                        ToolID: insertPowerToolId,
                        blade_size: req.body.blade_size
                    }
                    connection.query(insert_power_subtype, saw_tool, function (err) {
                        if (err) {
                            console.error("SQL connection error", err);
                            return next.err;
                        }
                        console.log("Electric Saw inserted");
                    })
                } else if (power_subtype === "sander") {
                    var sander_tool = {
                        ToolID: insertPowerToolId,
                        dust_bag: req.body.dust_bag
                    }
                    connection.query(insert_power_subtype, sander_tool, function (err) {
                        if (err) {
                            console.error("SQL connection error", err);
                            return next.err;
                        }
                        console.log("Electric Sander inserted");
                    })
                } else if (power_subtype === "aircompressor") {
                    var aircompressor_tool = {
                        ToolID: insertPowerToolId,
                        tank_size:req.body.tank_size,
                        pressure_rating:req.body.pressure_rating
                    }
                    connection.query(insert_power_subtype, aircompressor_tool, function (err) {
                        if (err) {
                            console.error("SQL connection error", err);
                            return next.err;
                        }
                        console.log("Air-compressor inserted");
                    })
                } else if (power_subtype === "mixer") {
                    var mixer_tool = {
                        ToolID: insertPowerToolId,
                        motor_rating: req.body.motor_rating,
                        drum_size:req.body.drum_size
                    }
                    connection.query(insert_power_subtype, mixer_tool, function (err) {
                        if (err) {
                            console.error("SQL connection error", err);
                            return next.err;
                        }
                        console.log("Mixer inserted");
                    })
                } else if (power_subtype === "generator") {
                    var generator_tool = {
                        ToolID: insertPowerToolId,
                        power_rating: req.body.power_rating
                    }
                    connection.query(insert_power_subtype, generator_tool, function (err) {
                        if (err) {
                            console.error("SQL connection error", err);
                            return next.err;
                        }
                        console.log("Generator inserted");
                    })
                }
            }
        })
    }
    res.redirect("/add_tool");
})

/* GET add_tool page. */

module.exports = router;
